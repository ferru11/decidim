# frozen_string_literal: true
require "spec_helper"

module Decidim
  describe Identity, :db do
    let(:user) { create(:user) }
    let(:provider) { "facebook" }
    let(:uid) { "123456" }
    let(:identity) { build(:identity, user: user, provider: provider, uid: uid) }
    subject { identity }

    it { is_expected.to be_valid }
    
    it "has an associated user" do
      expect(subject.user).to be_a(Decidim::User)
    end

    describe "validations" do
      context "when the user is not present" do
        let(:user) { nil }
        it { is_expected.to be_invalid }
      end

      context "when the provider is not present" do
        let(:provider) { nil }
        it { is_expected.to be_invalid }
      end

      context "when the uid is not present" do
        let(:uid) { nil }
        it { is_expected.to be_invalid }        
      end

      it "is invalid if the uid already exists for the same provider" do
        identity.save
        other_identity = build(:identity, provider: identity.provider, uid: identity.uid)
        expect(other_identity).to be_invalid
      end
    end
  end
end
