class AnswerMailer < ApplicationMailer

    # To deliver the mail created by this method, do:
  # AnswerMailer.hello_world.deliver
  def hello_world

    mail(
      to: "steve@codecore.ca",
      from: "info@awesome-answers.com",
      cc: "jj@movies.com",
      bcc: "someone.else@example.com",
      subject: "Hello, World!"
    )
  end

  # To deliver mail, use the following method:
  # AnswerMailer.notify_question_owner(Answer.last).deliver
  def notify_question_owner(answer)
    @answer = answer
    @question = answer.question
    @question_owner = @question.user

    mail(
      to: @question_owner.email,
      subject: "#{answer.user.first_name} answered your question!"
    )
  end
end
