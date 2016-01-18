require 'csv'

class Question
  attr_reader :strand_id, :strand_name, :standard_id, :standard_name, :question_id, :difficulty

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

def build_strand_hash

end

def create_quiz(num_of_questions, questions)
  strand_count = {}
  questions.each do |question|
    if strand_count[question.strand_id] == nil
      strand_count[question.strand_id] = 1
    else
      strand_count[question.strand_id] += 1
    end
  end
  p strand_count
  current_strand_count = {}
  strand_count.each do |k,v|
    if current_strand_count[k] == nil
      current_strand_count[k] = 0
    end
  end
  p strand_max = questions.length / strand_count.length
  final_questions = []
  questions.each do |question|
    if current_strand_count[question.strand_id] <= current_strand_count.max_by{|k,v| v}[1] && num_of_questions > 0 && current_strand_count[question.strand_id] <= strand_max
      final_questions.push(question)
      strand_count[question.strand_id] += 1
      num_of_questions -= 1
    end
  end
  final_questions
end

quiz_questions = parse_question_csv

p create_quiz(4, quiz_questions)

# p questions
