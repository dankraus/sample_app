require 'spec_helper'

describe Relationship Controller
	
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { signin_user }

	describe "creating a relationship with AJAX" do
		it "should increment the Relationship count" do
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.should change(Relationship, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			reponse.should be_success
		end
	end

	describe "destroying a relationship with AJAX" do
		before { user.follow!(other_user) }
		let(:relationship) { user.relationships.find_by_followed_id(other_user) }

		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.should change(Relationship, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			response.should be_success
		end
	end
end