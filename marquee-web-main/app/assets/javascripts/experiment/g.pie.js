/*
 * g.Raphael 0.4.1 - Charting library, based on Raphaël
 *
 * Copyright (c) 2009 Dmitry Baranovskiy (http://g.raphaeljs.com)
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
 */
(function () {
    var defcolors = (function () {
            var hues = [.6, .2, .05, .1333, .75, 0],
                colors = [];

            for (var i = 0; i < 10; i++) {
                if (i < hues.length) {
                    colors.push('hsb(' + hues[i] + ',.75, .75)');
                } else {
                    colors.push('hsb(' + hues[i - hues.length] + ', 1, .5)');
                }
            }

            return colors;
        })(),
        shim = { stroke: 'none', fill: '#000', 'fill-opacity': 0 },
        txtattr = { font: '13px Grill Sans' };

    function labelise(label, val, total) {
        if (label) {
            return (label + "").replace(/(##+(?:\.#+)?)|(%%+(?:\.%+)?)/g, function (all, value, percent) {
                if (value) {
                    return (+val).toFixed(value.replace(/^#+\.?/g, "").length);
                }
                if (percent) {
                    return (val * 100 / total).toFixed(percent.replace(/^%+\.?/g, "").length) + "%";
                }
            });
        } else {
            return (+val).toFixed(0);
        }
    };

    Raphael.fn.piechart = function (cx, cy, r, values, opts) {
        opts = opts || {};

        var paper = this,
            sectors = [],
            covers = this.set(),
            chart = this.set(),
            series = this.set(),
            order = [],
            len = values.length,
            angle = 0,
            total = 0,
            others = 0,
            cut = 9,
            defcut = true;

        function sector(cx, cy, r, startAngle, endAngle, fill) {
            var rad = Math.PI / 180,
                x1 = cx + r * Math.cos(-startAngle * rad),
                x2 = cx + r * Math.cos(-endAngle * rad),
                xm = cx + r / 2 * Math.cos(-(startAngle + (endAngle - startAngle) / 2) * rad),
                y1 = cy + r * Math.sin(-startAngle * rad),
                y2 = cy + r * Math.sin(-endAngle * rad),
                ym = cy + r / 2 * Math.sin(-(startAngle + (endAngle - startAngle) / 2) * rad),
                res = [
                    "M", cx, cy,
                    "L", x1, y1,
                    "A", r, r, 0, +(Math.abs(endAngle - startAngle) > 180), 1, x2, y2,
                    "z"
                ];

            res.middle = { x: xm, y: ym };
            return res;
        }

        chart.covers = covers;

        if (len == 1) {
            series.push(this.circle(cx, cy, r).attr({ fill: defcolors[0], stroke: opts.stroke || "#fff", "stroke-width": opts.strokewidth == null ? 1 : opts.strokewidth }));
            covers.push(this.circle(cx, cy, r).attr(shim));
            total = values[0];
            values[0] = { value: values[0], order: 0, valueOf: function () { return this.value; } };
            series[0].middle = {x: cx, y: cy};
            series[0].mangle = 180;
        } else {
            for (var i = 0; i < len; i++) {
                total += values[i];
                values[i] = { value: values[i], order: i, valueOf: function () { return this.value; } };
            }

            values.sort(function (a, b) {
                return b.value - a.value;
            });

            for (i = 0; i < len; i++) {
                if (defcut && values[i] * 360 / total <= 1.5) {
                    cut = i;
                    defcut = false;
                }

                if (i > cut) {
                    defcut = false;
                    values[cut].value += values[i];
                    values[cut].others = true;
                    others = values[cut].value;
                }
            }

            len = Math.min(cut + 1, values.length);
            others && values.splice(len) && (values[cut].others = true);

            for (i = 0; i < len; i++) {
                var mangle = angle - 360 * values[i] / total / 2;

                if (!i) {
                    angle = 90 - mangle;
                    mangle = angle - 360 * values[i] / total / 2;
                }

                if (opts.init) {
                    var ipath = sector(cx, cy, 1, angle, angle - 360 * values[i] / total).join(",");
                }

                var path = sector(cx, cy, r, angle, angle -= 360 * values[i] / total);
                var p = this.path(opts.init ? ipath : path).attr({ fill: opts.colors && opts.colors[i] || defcolors[i] || "#666", stroke: opts.stroke || "#fff", "stroke-width": (opts.strokewidth == null ? 1 : opts.strokewidth), "stroke-linejoin": "round" });

                p.value = values[i];
                p.middle = path.middle;
                p.mangle = mangle;
                sectors.push(p);
                series.push(p);
                opts.init && p.animate({ path: path.join(",") }, (+opts.init - 1) || 1000, ">");
            }

            for (i = 0; i < len; i++) {
                p = paper.path(sectors[i].attr("path")).attr(shim);
                opts.href && opts.href[i] && p.attr({ href: opts.href[i] });
                p.attr = function () {};
                covers.push(p);
                series.push(p);
            }
        }

        chart.hover = function (fin, fout) {
            fout = fout || function () {};

            var that = this;

            for (var i = 0; i < len; i++) {
                (function (sector, cover, j) {
                    var o = {
                        sector: sector,
                        cover: cover,
                        cx: cx,
                        cy: cy,
                        mx: sector.middle.x,
                        my: sector.middle.y,
                        mangle: sector.mangle,
                        r: r,
                        value: values[j],
                        total: total,
                        label: that.labels && that.labels[j]
                    };
                    cover.mouseover(function () {
                        fin.call(o);
                    }).mouseout(function () {
                        fout.call(o);
                    });
                })(series[i], covers[i], i);
            }
            return this;
        };

        // x: where label could be put
        // y: where label could be put
        // value: value to show
        // total: total number to count %
        chart.each = function (f) {
            var that = this;

            for (var i = 0; i < len; i++) {
                (function (sector, cover, j) {
                    var o = {
                        sector: sector,
                        cover: cover,
                        cx: cx,
                        cy: cy,
                        x: sector.middle.x,
                        y: sector.middle.y,
                        mangle: sector.mangle,
                        r: r,
                        value: values[j],
                        total: total,
                        label: that.labels && that.labels[j]
                    };
                    f.call(o);
                })(series[i], covers[i], i);
            }
            return this;
        };

        chart.click = function (f) {
            var that = this;

            for (var i = 0; i < len; i++) {
                (function (sector, cover, j) {
                    var o = {
                        sector: sector,
                        cover: cover,
                        cx: cx,
                        cy: cy,
                        mx: sector.middle.x,
                        my: sector.middle.y,
                        mangle: sector.mangle,
                        r: r,
                        value: values[j],
                        total: total,
                        label: that.labels && that.labels[j]
                    };
                    cover.click(function () { f.call(o); });
                })(series[i], covers[i], i);
            }
            return this;
        };

        chart.inject = function (element) {
            element.insertBefore(covers[0]);
        };

        var legend = function (labels, otherslabel, mark, dir, margin) {
            margin = margin || 40
            var x = cx + r + r / 5 - margin,
                y = cy,
                h = y + 10;

            labels = labels || [];
            dir = (dir && dir.toLowerCase && dir.toLowerCase()) || "east";
            mark = paper[mark && mark.toLowerCase()] || "circle";
            chart.labels = paper.set();

            for (var i = 0; i < len; i++) {
                var clr = series[i].attr("fill"),
                    j = values[i].order,
                    txt;

                values[i].others && (labels[j] = otherslabel || "Others");
                labels[j] = labelise(labels[j], values[i], total);
                chart.labels.push(paper.set());
                chart.labels[i].push(paper[mark](x + 5, h, 5).attr({ fill: clr, stroke: "none" }));
                chart.labels[i].push(txt = paper.text(x + 20, h, labels[j] || values[j]).attr(txtattr).attr({ fill: opts.legendcolor || "#000", "text-anchor": "start"}));
                covers[i].label = chart.labels[i];
                h += txt.getBBox().height * 1.2;
            }

            var bb = chart.labels.getBBox(),
                tr = {
                    east: [0, -bb.height / 2],
                    west: [-bb.width - 2 * r - 20, -bb.height / 2],
                    north: [-r - bb.width / 2, -r - bb.height - 10],
                    south: [-r - bb.width / 2, r + 10]
                }[dir];

            chart.labels.translate.apply(chart.labels, tr);
            chart.push(chart.labels);
        };

        if (opts.legend) {
            legend(opts.legend, opts.legendothers, opts.legendmark, opts.legendpos, opts.legendmargin);
        }

        chart.push(series, covers);
        chart.series = series;
        chart.covers = covers;

        return chart;
    };
})();