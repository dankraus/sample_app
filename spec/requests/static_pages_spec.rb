require 'spec_helper'

describe "Static pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1',    text: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end


	describe "Home page" do
		before { visit root_path }

		let(:heading)    { 'Sample App' }
		let(:page_title) { '' }

		it_should_behave_like "all static pages"
		it { should_not have_selector 'title', text: '| Home' }

		it "should have the right links on the layout" do
			visit root_path
			click_link "About"
			page.should have_selector 'title', text: full_title('About Us')
			click_link "Help"
			page.should have_selector 'title', text: full_title('Help')
			click_link "Contact"
			page.should have_selector 'title', text: full_title('Contact')
			click_link "Home"
			page.should have_selector 'title', text: full_title('')
			click_link "Sign up now!"
			page.should have_selector 'title', text: full_title('Sign up')
		end

	describe "for signed in users" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
			sign_in user
			visit root_path
        end

		it "should show micropost count" do
			page.should have_selector("span.count")
		end

		it "should show correct micropost count and pluralization" do
			page.should have_selector("span.count", text: '1 micropost')
		end

		it "should show correct micropost count and pluralization" do
			#we already have 1 micropost for the user, add one more and test for correct pluralization
			FactoryGirl.create(:micropost, user: user, content: "Dolor set est")
			sign_in user
			visit root_path
			page.should have_selector("span.count", text: '2 microposts')
		end

		it "should display the user's feed" do
			user.feed.each do |item|
				page.should have_selector("li##{item.id}", text: item.content)
			end
		end

		describe "follower/following counts"
			let(:other_user) { FactoryGirl.create(:user) }
			before do
				other_user.follow!(user)
				visit root_path
			end

			it { should have_link("0 following"), following_user_path(user)}
			it { should have_link("1 follower"), followers_user_path(user) }
		end
	end


	describe "Help page" do
		before { visit help_path }

		let(:heading)    { 'Help' }
		let(:page_title) { 'Help' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }

		let(:heading)    { 'About' }
		let(:page_title) { 'About' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }

		let(:heading)    { 'Contact' }
		let(:page_title) { 'Contact' }

		it_should_behave_like "all static pages"
  end
end