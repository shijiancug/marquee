require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Admin::CiMappingsController do

  # This should return the minimal set of attributes required to create a valid
  # Admin::CiMapping. As you add validations to Admin::CiMapping, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all admin_ci_mappings as @admin_ci_mappings" do
      ci_mapping = Admin::CiMapping.create! valid_attributes
      get :index
      assigns(:admin_ci_mappings).should eq([ci_mapping])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_ci_mapping as @admin_ci_mapping" do
      ci_mapping = Admin::CiMapping.create! valid_attributes
      get :show, :id => ci_mapping.id.to_s
      assigns(:admin_ci_mapping).should eq(ci_mapping)
    end
  end

  describe "GET new" do
    it "assigns a new admin_ci_mapping as @admin_ci_mapping" do
      get :new
      assigns(:admin_ci_mapping).should be_a_new(Admin::CiMapping)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_ci_mapping as @admin_ci_mapping" do
      ci_mapping = Admin::CiMapping.create! valid_attributes
      get :edit, :id => ci_mapping.id.to_s
      assigns(:admin_ci_mapping).should eq(ci_mapping)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::CiMapping" do
        expect {
          post :create, :admin_ci_mapping => valid_attributes
        }.to change(Admin::CiMapping, :count).by(1)
      end

      it "assigns a newly created admin_ci_mapping as @admin_ci_mapping" do
        post :create, :admin_ci_mapping => valid_attributes
        assigns(:admin_ci_mapping).should be_a(Admin::CiMapping)
        assigns(:admin_ci_mapping).should be_persisted
      end

      it "redirects to the created admin_ci_mapping" do
        post :create, :admin_ci_mapping => valid_attributes
        response.should redirect_to(Admin::CiMapping.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_ci_mapping as @admin_ci_mapping" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::CiMapping.any_instance.stub(:save).and_return(false)
        post :create, :admin_ci_mapping => {}
        assigns(:admin_ci_mapping).should be_a_new(Admin::CiMapping)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::CiMapping.any_instance.stub(:save).and_return(false)
        post :create, :admin_ci_mapping => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_ci_mapping" do
        ci_mapping = Admin::CiMapping.create! valid_attributes
        # Assuming there are no other admin_ci_mappings in the database, this
        # specifies that the Admin::CiMapping created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin::CiMapping.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => ci_mapping.id, :admin_ci_mapping => {'these' => 'params'}
      end

      it "assigns the requested admin_ci_mapping as @admin_ci_mapping" do
        ci_mapping = Admin::CiMapping.create! valid_attributes
        put :update, :id => ci_mapping.id, :admin_ci_mapping => valid_attributes
        assigns(:admin_ci_mapping).should eq(ci_mapping)
      end

      it "redirects to the admin_ci_mapping" do
        ci_mapping = Admin::CiMapping.create! valid_attributes
        put :update, :id => ci_mapping.id, :admin_ci_mapping => valid_attributes
        response.should redirect_to(ci_mapping)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_ci_mapping as @admin_ci_mapping" do
        ci_mapping = Admin::CiMapping.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::CiMapping.any_instance.stub(:save).and_return(false)
        put :update, :id => ci_mapping.id.to_s, :admin_ci_mapping => {}
        assigns(:admin_ci_mapping).should eq(ci_mapping)
      end

      it "re-renders the 'edit' template" do
        ci_mapping = Admin::CiMapping.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::CiMapping.any_instance.stub(:save).and_return(false)
        put :update, :id => ci_mapping.id.to_s, :admin_ci_mapping => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_ci_mapping" do
      ci_mapping = Admin::CiMapping.create! valid_attributes
      expect {
        delete :destroy, :id => ci_mapping.id.to_s
      }.to change(Admin::CiMapping, :count).by(-1)
    end

    it "redirects to the admin_ci_mappings list" do
      ci_mapping = Admin::CiMapping.create! valid_attributes
      delete :destroy, :id => ci_mapping.id.to_s
      response.should redirect_to(admin_ci_mappings_url)
    end
  end

end
