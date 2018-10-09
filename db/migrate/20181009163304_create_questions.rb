# Migrations, like many other parts of Rails, have what you can call a DSL
# Domain Specific Language. It's just Ruby code but written in a clever fashion
# which makes it seems like its own language.
class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    # this mingration `instruction` is used to create a table in the database
    # and doing the reverse as well (drop table in this case)
    # by default, every table will have an Integer primary key called: id
    create_table :questions do |t|
      t.string :title
      t.text :body

      # t.timestamps is added by default but you can remove, it generates two
      # fields: created_at & updated_at. These fields are automatically set by
      # ActiveRecord and they come in handy in many cases. It's recommended that you
      # keep them.
      t.timestamps
    end
  end
end

# rails db:migrate -> will execute all migrate that haven't been executed
# rails db:rollback -> will run the reverse of the last executed migration
