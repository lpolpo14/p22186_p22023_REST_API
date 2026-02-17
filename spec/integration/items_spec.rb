require 'swagger_helper'

RSpec.describe 'Items API', type: :request do
  let(:user) { create(:user) }

  let!(:todo) { create(:todo, created_by: user.id) }
  let(:todo_id) { todo.id }

  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:id) { items.first.id }

  path '/todos/{todo_id}/items' do
    parameter name: :todo_id, in: :path, type: :string, description: 'Todo id'

    get 'List todo items' do
      security [ { jwt: [] } ]
      tags 'Todo Items'
      produces 'application/json'

      response '200', 'items listed' do
        run_test!
      end

      response '404', 'todo not found' do
        let(:todo_id) { '0' }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    post 'Create a todo item' do
      tags 'Todo Items'
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'

      security [ { jwt: [] } ]
      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        },
        required: ['name']
      }

      response '201', 'item created' do
        let(:item) { { name: 'Visit Narnia', done: false } }
        run_test!
      end

      response '422', 'validation failed' do
        let(:item) { {} }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:item) { { name: 'Visit Narnia', done: false } }
        run_test!
      end
    end
  end

  path '/todos/{todo_id}/items/{id}' do
    parameter name: :todo_id, in: :path, type: :string, description: 'Todo id'
    parameter name: :id, in: :path, type: :string, description: 'Item id'


    get 'Get a todo item' do
      security [ { jwt: [] } ]
      tags 'Todo Items'
      produces 'application/json'

      response '200', 'item found' do
        run_test!
      end

      response '404', 'item not found' do
        let(:id) { '0' }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    put 'Update a todo item' do
      tags 'Todo Items'
      consumes 'application/x-www-form-urlencoded'

      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean }
        }
      }
      security [ { jwt: [] } ]

      response '204', 'item updated' do
        let(:item) { { name: 'Mozart' } }
        run_test!
      end

      response '404', 'item not found' do
        let(:id) { '0' }
        let(:item) { { name: 'Mozart' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:item) { { name: 'Mozart' } }
        run_test!
      end
    end

    delete 'Delete a todo item' do
      tags 'Todo Items'
      security [ { jwt: [] } ]

      response '204', 'item deleted' do
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end
end

