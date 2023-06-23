require_relative 'book'
require_relative 'person'
require_relative 'rental'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def run
    puts 'Welcome to the Console Library App!'

    loop do
      puts "\nPlease choose an option:"
      puts '1. List all books'
      puts '2. List all people'
      puts '3. Create a person'
      puts '4. Create a book'
      puts '5. Create a rental'
      puts '6. List rentals for a person'
      puts '7. Quit'

      choice = gets.chomp.to_i

      case choice
      when 1
        list_all_books
      when 2
        list_all_people
      when 3
        create_person
      when 4
        create_book
      when 5
        create_rental
      when 6
        list_rentals_for_person
      when 7
        puts 'Thank you for using the Console Library App. Goodbye!'
        break
      else
        puts 'Invalid option. Please try again.'
      end
    end
  end

  private

  def list_all_books
    if @books.empty?
      puts 'No books available.'
    else
      puts 'Listing all books:'
      @books.each { |book| puts "#{book.title} by #{book.author}" }
    end
  end

  def list_all_people
    if @people.empty?
      puts 'No people available.'
    else
      puts 'Listing all people:'
      @people.each { |person| puts "#{person.name} (ID: #{person.id})" }
    end
  end

  def create_person
    puts 'Enter person details:'
    print 'Name: '
    name = gets.chomp
    print 'Age: '
    age = gets.chomp.to_i
    print 'Is a teacher? (y/n): '
    is_teacher = gets.chomp.downcase == 'y'

    if is_teacher
      print 'Specialization: '
      specialization = gets.chomp
      person = Teacher.new(age, name, specialization)
    else
      print 'Classroom label: '
      classroom_label = gets.chomp
      classroom = find_classroom_by_label(classroom_label)
      if classroom.nil?
        puts 'Classroom not found. Creating a new one.'
        classroom = Classroom.new(classroom_label)
      end
      person = Student.new(classroom)
    end

    @people << person
    puts 'Person created successfully.'
  end

  def create_book
    puts 'Enter book details:'
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp

    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully.'
  end

  def create_rental
    puts 'Enter rental details:'
    print 'Person ID: '
    person_id = gets.chomp.to_i
    person = find_person_by_id(person_id)
    if person.nil?
      puts 'Person not found.'
      return
    end

    print 'Book title: '
    book_title = gets.chomp
    book = find_book_by_title(book_title)
    if book.nil?
      puts 'Book not found.'
      return
    end

    print 'Rental date: '
    rental_date = gets.chomp

    rental = person.add_rental(book, rental_date)
    @rentals << rental

    puts 'Rental created successfully.'
  end

  def list_rentals_for_person
    print 'Enter person ID: '
    person_id = gets.chomp.to_i
    person = find_person_by_id(person_id)
    if person.nil?
      puts 'Person not found.'
      return
    end

    rentals = @rentals.select { |rental| rental.person == person }

    if rentals.empty?
      puts 'No rentals found for the person.'
    else
      puts "Listing rentals for #{person.name}:"
      rentals.each do |rental|
        puts "Book: #{rental.book.title}, Rental Date: #{rental.date}"
      end
    end
  end

  def find_person_by_id(person_id)
    @people.find { |person| person.id == person_id }
  end

  def find_book_by_title(book_title)
    @books.find { |book| book.title == book_title }
  end

  def find_classroom_by_label(classroom_label)
    @people.each do |person|
      if person.is_a?(Student) && person.classroom.label == classroom_label
        return person.classroom
      end
    end
    nil
  end
end