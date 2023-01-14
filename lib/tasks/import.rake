require 'csv'

task :import, [:customers] => :environment do
  CSV.foreach('db/data/customers.csv', headers: true) do |row|
    Customer.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  puts "Customers imported."
end

task :import, [:merchants] => :environment do
  CSV.foreach('db/data/merchants.csv', headers: true) do |row|
    Merchant.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  puts "Merchants imported."
end

task :import, [:items] => :environment do
  CSV.foreach('db/data/items.csv', headers: true) do |row|
    Item.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('items')
  puts "Items imported."
end

task :import, [:invoices] => :environment do
  CSV.foreach('db/data/invoices.csv', headers: true) do |row|
    if row.to_hash['status'] == 'cancelled'
      status = 0
    elsif row.to_hash['status'] == 'in progress'
      status = 1
    elsif row.to_hash['status'] == 'completed'
      status = 2
    end
    Invoice.create!({ id:          row[0],
                      customer_id: row[1],
                      status:      status,
                      created_at:  row[4],
                      updated_at:  row[5] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  puts "Invoices imported."
end

task :import, [:transactions] => :environment do
  CSV.foreach('db/data/transactions.csv', headers: true) do |row|
    if row.to_hash['result'] == 'failed'
      result = 0
    elsif row.to_hash['result'] == 'success'
      result = 1
    end
    Transaction.create!({ id:                          row[0],
                          invoice_id:                  row[1],
                          credit_card_number:          row[2],
                          credit_card_expiration_date: row[3],
                          result:                      result,
                          created_at:                  row[5],
                          updated_at:                  row[6] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  puts "Transactions imported."
end

task :import, [:invoice_items] => :environment do
  CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
    if row.to_hash['status'] == 'pending'
      status = 0
    elsif row.to_hash['status'] == 'packaged'
      status = 1
    elsif row.to_hash['status'] == 'shipped'
      status = 2
    end
    InvoiceItem.create!({ id:          row[0],
                          item_id:     row[1],
                          invoice_id:  row[2],
                          quantity:    row[3],
                          unit_price:  row[4],
                          status:      status,
                          created_at:  row[6],
                          updated_at:  row[7] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  puts "InvoiceItems imported."
end
task :import, [:all] => :environment do
  Rake::Task["import:merchants"].invoke
  Rake::Task["import:items"].invoke
  Rake::Task["import:customers"].invoke
  Rake::Task["import:invoices"].invoke
  Rake::Task["import:invoice_items"].invoke
  Rake::Task["import:transactions"].invoke
end