require 'spec_helper'

describe Like do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:micropost) { FactoryGirl.create(:micropost, user: other_user) }
  before do
    @like = user.likes.build(micropost_id: micropost.id)
  end

  subject { @like }

  it { should respond_to(:micropost_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:micropost) }

  its(:user) { should eq user }
  its(:micropost) { should eq other_user.microposts.first }
  it { should be user.likes.first }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @like.user_id = nil }
    it { should_not be_valid }
  end

  describe "when micropost_id is not present" do
    before { @like.micropost_id = nil }
    it { should_not be_valid }
  end
end
