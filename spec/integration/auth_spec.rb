require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  let(:headers) { valid_headers.except('Authorization') }

  path '/signup' do
    post 'Signup' do
      tags 'Auth'
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Mike' },
          email: { type: :string, example: 'p22186@unipi.gr' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' }
        },
        required: %w[name email password password_confirmation]
      }

      response '201', 'account created' do
        let(:user) do
          {
            name: 'Mike',
            email: 'p22186@unipi.gr',
            password: 'password123',
            password_confirmation: 'password123'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['auth_token']).not_to be_nil
          expect(data['message']).to match(/Account created successfully/i)
        end
      end

      response '422', 'validation failed' do
        let(:user) { {} }

        run_test!
      end
    end
  end

  path '/auth/login' do
    post 'Login' do
      tags 'Auth'
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'p22186@unipi.gr' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response '200', 'login successful' do
        let!(:user) { create(:user, email: 'mike@example.com', password: 'password123') }

        let(:credentials) do
          {
            email: 'p22186@unipi.gr',
            password: 'password123'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['auth_token']).not_to be_nil
        end
      end

      response '401', 'invalid credentials' do
        let(:credentials) do
          {
            email: 'invalidEmail@unippi.gr',
            password: 'wrong_password'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to match(/Invalid credentials/i)
        end
      end
    end
  end

  path '/auth/logout' do
    get 'Logout' do
      tags 'Auth'
      produces 'application/json'
      security [ { jwt: [] } ]

      response '200', 'logged out' do
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end
end

