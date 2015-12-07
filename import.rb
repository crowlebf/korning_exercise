require 'pry'
require 'pg'
require 'csv'

  def db_connection
    begin
      connection = PG.connect(dbname: "korning")
      yield(connection)
    ensure
      connection.close
    end
  end

  def insert_value(table, column, row)
    duplicate_array = []
    @sales_array.each do |sale_row|
      db_connection do |conn|
        if duplicate_array.include?("#{sale_row[row]}")
          next
        else
          begin
            conn.exec_params("INSERT INTO #{table} (#{column}) VALUES ('#{sale_row[row]}')")
            duplicate_array << "#{sale_row[row]}"
          rescue
            next
          end
        end
      end
    end
  end

db_connection do |conn|
  @sales_array = conn.exec_params("SELECT * FROM metadata;").to_a
end

insert_value("employee", "emp_name", "emp_id")
insert_value("customer_and_account_info", "customer_and_account_no", "customer_and_account_id")
insert_value("invoice_frequency", "invoice_frequency", "invoice_frequency_id")
insert_value("products", "product_name", "product_id")

db_connection do |conn|
  conn.exec_params("INSERT INTO invoice_header (
  emp_id
  ,customer_and_account_id
  ,product_id
  ,sale_date
  ,sale_amount
  ,units_sold
  ,invoice_no
  ,invoice_frequency_id)
    SELECT emp.emp_id, cai.customer_and_account_id, prod.product_id, a.sale_date, a.sale_amount, a.units_sold, a.invoice_no, freq.invoice_freq_id FROM metadata a
    LEFT JOIN employee emp
      ON emp.emp_name = a.emp_id
    LEFT JOIN customer_and_account_info cai
      ON cai.customer_and_account_no = a.customer_and_account_id
    LEFT JOIN products prod
      ON prod.product_name = a.product_id
    LEFT JOIN invoice_frequency freq
      ON freq.invoice_frequency = a.invoice_frequency_id
  ")
end
