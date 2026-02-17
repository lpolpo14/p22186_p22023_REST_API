require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do 
  let(:user) { create(:user) }
  let(:todo) { create(:todo, created_by: user.id) }
  let(:id) { todo.id }

  path '/todos' do 
    get 'List all Todos' do 
      security [ { jwt: [] } ]
      tags 'Todos'
      produces 'application/json'

      response '200', 'todos listed' do 
        before do 
          create_list(:todo, 3, created_by: user.id)
        end

        run_test!
        end

      response '401', 'unauthorized' do
        run_test!
      end

    end

    post 'Create a new todo' do
      tags 'Todos'
      security [ { jwt: [] } ]
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          created_by: { type: :string}
        },
        required: ['title']
      }

      response '201', 'todo created' do
        let(:todo) { { title: 'Learn Elm' } }
        run_test!
      end

      response '422', 'validation failed' do
        let(:todo) { { title: nil } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:todo) { { title: 'Learn Elm' } }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Todo id'

    get 'Get a todo' do
      tags 'Todos'
      produces 'application/json'
      security [ { jwt: [] } ]


      response '200', 'todo found' do
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { '0' }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    put 'Update a todo' do
      tags 'Todos'
      consumes 'application/x-www-form-urlencoded'
      security [ { jwt: [] } ]

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        }
      }

      response '204', 'todo updated' do
        let(:todo) { { title: 'Shopping' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:todo) { { title: 'Shopping' } }
        run_test!
      end
    end

    delete 'Delete a todo and its items' do
      tags 'Todos'
      security [ { jwt: [] } ]

      response '204', 'todo deleted' do
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end
end

