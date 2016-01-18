require 'csv'

class Question
  def initialize(args)
    @strand_id = args[:strand_id]
    @strand_name = args[:strand_name]
    @standard_id = args[:standard_id]
    @standard_name = args[:standard_name]
    @question_id = args[:question_id]
    @difficulty = args[:difficulty]
  end
end

def get_quiz_length
  p "How many questions would you like in the quiz?"
  num_of_questions = gets.chomp
  if num_of_questions > 0
    p "Thank you, preparing quiz with #{num_of_questions}."
  else
    p "Number needs to be greater than 0"
  end
end

def parse_question_csv
  questions = []
  index = 0
  CSV.foreach('questions.csv') do |row|
    if index != 0
      questions.push(Question.new(
        strand_id: row[0],
        strand_name: row[1],
        standard_id: row[2],
        standard_name: row[3],
        question_id: row[4],
        difficulty: row[5]
      ))
    end
    index += 1
  end
  questions
end

p parse_question_csv

# p questions
