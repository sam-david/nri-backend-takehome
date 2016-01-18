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
  num_of_questions = gets.chomp.to_i
  if num_of_questions > 0
    p "Thank you, preparing quiz with #{num_of_questions} questions."
    num_of_questions
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

def create_quiz(num_of_questions, questions)
  strand_count = {}
  questions.each do |question|
    if strand_count[question.strand_id] == nil
      strand_count[question.strand_id] = 1
    else
      strand_count[question.strand_id] += 1
    end
  end
  current_strand_count = {}
  strand_count.each do |k,v|
    if current_strand_count[k] == nil
      current_strand_count[k] = 0
    end
  end
  strand_max = num_of_questions / strand_count.length
  final_questions = []
  questions.each do |question|
    if current_strand_count[question.strand_id] <= strand_max && num_of_questions > 0
      final_questions.push(question)
      current_strand_count[question.strand_id] += 1
      num_of_questions -= 1
    end
  end
  final_questions.sort_by do |question|
    question.difficulty
  end
end

def output_quiz(questions)
  p 'Quiz question IDs'
  questions.each do |question|
    p question.question_id
  end
end

all_quiz_questions = parse_question_csv
num_of_questions = get_quiz_length
final_quiz_questions = create_quiz(num_of_questions, all_quiz_questions)
output_quiz(final_quiz_questions)

