require 'grape'

module Api
  class TeachingPeriods < Grape::API
    helpers AuthenticationHelpers
    helpers AuthorisationHelpers

    before do
      authenticated?
    end

    desc 'Add a Teaching Period'
    params do
      requires :teaching_period, type: Hash do
        optional :period, type: String, desc: 'The name of the teaching period'
        optional :start_date, type: Date, desc: 'The start date of the teaching period'
        optional :end_date, type: Date, desc: 'The end date of the teaching period'
      end
    end
    post '/teaching_periods' do
      unless authorise? current_user, User, :handle_teaching_period
        error!({ error: 'Not authorised to create a teaching period' }, 403)
      end
      teaching_period_parameters = ActionController::Parameters.new(params)
                                                               .require(:teaching_period)
                                                               .permit(:period,
                                                                       :start_date,
                                                                       :end_date)

      result = TeachingPeriod.create!(teaching_period_parameters)

      if result.nil?
        error!({ error: 'No teaching period added.' }, 403)
      else
        result
      end
    end

    desc "Get a teaching period's details"
    get '/teaching_periods/:id' do
      teaching_period = TeachingPeriod.find(params[:id])
      unless (authorise? current_user, User, :get_teaching_periods) || (authorise? current_user, User, :handle_teaching_period)
        error!({ error: "Couldn't find Teaching Period with id=#{params[:id]}" }, 403)
      end
      teaching_period
    end

    desc 'Update teaching period'
    params do
      requires :id, type: Integer, desc: 'The teaching period id to update'
      requires :teaching_period, type: Hash do
        optional :period, type: String, desc: 'The name of the teaching period'
        optional :start_date, type: Date, desc: 'The start date of the teaching period'
        optional :end_date, type: Date, desc: 'The end date of the teaching period'
      end
    end
    put '/teaching_periods/:id' do
      teaching_period = TeachingPeriod.find(params[:id])
      unless authorise? current_user, User, :handle_teaching_period
        error!({ error: 'Not authorised to update a teaching period' }, 403)
      end
      teaching_period_parameters = ActionController::Parameters.new(params)
                                                               .require(:teaching_period)
                                                               .permit(:period,
                                                                       :start_date,
                                                                       :end_date)

      teaching_period.update!(teaching_period_parameters)
      teaching_period
    end

    desc 'Get all the Teaching Periods'
    get '/teaching_periods' do
      unless authorise? current_user, User, :get_teaching_periods
        error!({ error: 'Not authorised to get teaching periods' }, 403)
      end
      teaching_periods = TeachingPeriod.all
      result = teaching_periods.map do |c|
        {
          id: c.id,
          period: c.period,
          start_date: c.start_date,
          end_date: c.end_date
        }
      end
      result
    end

    desc 'Delete a teaching period'
    delete '/teaching_periods/:teaching_period_id' do
      unless authorise? current_user, User, :handle_teaching_period
        error!({ error: 'Not authorised to delete a teaching period' }, 403)
      end

      teaching_period_id = params[:teaching_period_id]
      TeachingPeriod.find(teaching_period_id).destroy
    end
  end
end