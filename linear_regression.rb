### Script that obtains market stocks and infers its regression curves
### Miguel Marinhas, Quidgest, 2011

require 'matrix'

## infers polynomial equation of degree n coefficients from seen data 
def regression x, y, degree
  # mapping of x independant and y dependent variables to the matrix
  x_data = x.map {|xi| (0..degree).map{|pow| (xi**pow) }}
  
  # construction of matrix parts
  mx = Matrix[*x_data]
  my = Matrix.column_vector(y)
  
  # ((MxT*MX)^-1 * MxT * My).T
  return((mx.t * mx).inv * mx.t * my).transpose.to_a[0].reverse
end

## Obtain stock prices time series for a given company
filename = 'google_sorted.csv'
file = File.new(filename, 'r')

stocks = []
x = []
y = []
counter = 0

file.each_line("\n") do |row|
  columns = row.split(",")
  stocks[counter] = columns
  
  if counter > 0
    x[counter-1] = counter
    y[counter-1] = columns[4].to_f
    puts columns[4]
  end
  
  counter += 1
  
  ## for testing purposes
  ##break if file.lineno > 210
end

#new_val_x = stocks.size
new_val_x = x.pop
expected_val = y.pop

def polynomial_function_inference degree, coef, x
  if degree==1
    return coef[0]*(x)+coef[1]
  elsif degree==2
    return (coef[0]*(x**2) + coef[1]*x + coef[2])
  elsif degree==3
    return (coef[0]*(x**3) + coef[1]*(x**2) + coef[2]*x + coef[3])
  elsif degree==4
    return (coef[0]*(x**4) + coef[1]*(x**3) + coef[2]*(x**2) + coef[3]*x + coef[4])
  elsif degree==5
    return (coef[0]*(x**5) + coef[1]*(x**4) + coef[2]*(x**3) + coef[3]*(x**2) + coef[4]*x + coef[5])
  end
end

puts "Expected value is: " + expected_val.to_s

(1..5).each do |degree|
  coef = regression(x,y,degree)
  print "Poly Degree: " + degree.to_s + " - Estimated value: "
  actual_val = polynomial_function_inference(degree, coef, new_val_x)
  puts actual_val.to_s + " MSE: " + ((expected_val-actual_val)**2).to_s
end


