require 'spec_helper'

describe Reply do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }

  it "should create replies" do
    string = "@#{user.name.gsub(' ', '_')}, hello!"
    expect do
      3.times { FactoryGirl.create(:micropost, user: other_user, content: string) }
    end.to change(user.replies, :count).by(3)
  end

  it "should create multiple replies" do
    string = "@#{user.name.gsub(' ', '_')}, @#{another_user.name.gsub(' ', '_')} hello!"
    expectation = expect { FactoryGirl.create(:micropost, user: other_user, content: string) }
    expectation.to change { user.replies.count }.by(1)
    expectation.to change { another_user.replies.count }.by(1)
  end

  before do
    string = "@#{user.name.gsub(' ', '_')}, hello!"
    FactoryGirl.create(:micropost, user: other_user, content: string)
    @reply = user.replies.first
  end

  subject { @reply }

  it { should respond_to(:user_id) }
  it { should respond_to(:micropost_id) }
  it { should respond_to(:user) }
  it { should respond_to(:micropost) }

  its(:user) { should eq user }
  its(:micropost) { should eq other_user.microposts.first}

  it { should be_valid }

  describe "when user_id is not present" do
    before { @reply.user_id = nil }
    it { should_not be_valid }
  end

  describe "when micropost_id is not present" do
    before { @reply.micropost_id = nil }
    it { should_not be_valid }
  end
end
