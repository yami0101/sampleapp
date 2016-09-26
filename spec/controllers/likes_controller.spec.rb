require 'spec_helper'

describe LikesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:micropost) { FactoryGirl.create(:micropost, user: other_user) }

  before { sign_in user, no_capybara: true }

  describe "liking with Ajax" do
    it "should increment like count" do
      expect do
        xhr :post, :create, like: { micropost_id: micropost.id }
      end.to change(Like, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, like: { micropost_id: micropost.id }
      expect(response).to be_success
    end


    it "should not allow to like twice" do
      expect do
        2.times { xhr :post, :create, like: { micropost_id: micropost.id } }
      end.to raise_error(ActiveRecord::StatementInvalid)
    end

  end

  describe "unliking with Ajax" do

    before { user.like!(micropost) }
    let(:like) { user.likes.find_by(micropost_id: micropost.id) }


    it "should decrement the like count" do
      puts like.inspect
      expect do
        xhr :delete, :destroy, id: like.id
      end.to change(Like, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: like.id
      expect(response).to be_success
    end

    it "should not allow to unlike not liked" do
      expect do
        2.times { xhr :delete, :destroy, id: like.id }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

end
