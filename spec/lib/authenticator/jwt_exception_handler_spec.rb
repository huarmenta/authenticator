# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JWTExceptionHandler, type: :controller do
  controller(ApplicationController) do
    include JWTExceptionHandler # rubocop: disable RSpec/DescribedClass

    def test_missing_token
      raise JWTExceptionHandler::MissingToken
    end

    def test_invalid_token
      raise JWTExceptionHandler::InvalidToken
    end

    def test_expired_signature
      raise JWTExceptionHandler::ExpiredSignature
    end
  end

  before do
    routes.draw do
      get 'test_missing_token' => 'anonymous#test_missing_token'
      get 'test_invalid_token' => 'anonymous#test_invalid_token'
      get 'test_expired_signature' => 'anonymous#test_expired_signature'
    end
  end

  describe 'JWTExceptionHandler::MissingToken' do
    context 'when exception is raised' do
      it do
        expect { get :test_missing_token }.to raise_error(
          JWTExceptionHandler::MissingToken
        )
      end
    end
  end

  describe 'JWTExceptionHandler::InvalidToken' do
    context 'when exception is raised' do
      it do
        expect { get :test_invalid_token }.to raise_error(
          JWTExceptionHandler::InvalidToken
        )
      end
    end
  end

  describe 'JWTExceptionHandler::ExpiredSignature' do
    context 'when exception is raised' do
      it do
        expect { get :test_expired_signature }.to raise_error(
          JWTExceptionHandler::ExpiredSignature
        )
      end
    end
  end
end
