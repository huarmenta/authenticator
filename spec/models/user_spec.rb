# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(described_class.table_name).to eq('authenticator_users') }
end
