require 'grape'
require 'project_serializer'

module Api
  class Settings < Grape::API

    #
    # Returns the current auth method
    #
    desc 'Return configurable details for the Doubtfire front end'
    get '/settings' do
      {
        externalName: Doubtfire::Application.config.institution[:product_name]
      }
    end

    #
    # Returns the privacy policy
    #
    desc 'Return configurable details for the Doubtfire front end'
    get '/settings/privacy' do
      {
        privacyPolicy: Doubtfire::Application.config.institution[:privacy_statement]
      }
    end

    #
    # Returns the current units with teaching periods
    # Return:
    # Unit Name, unit ID, teaching period name, year
    #
    desc 'Return all the units teaching period information'
    get '/settings/teaching_period_units' do
      # units_with_teaching_periods = Unit.where('teaching_period_id is not NULL').select([:id, :name, :code, :teaching_period_id])
      # units_with_teaching_periods.map do |unit|
      #   {
      #     unit_id: unit.id,
      #     unit_code: unit.code,
      #     period_name: TeachingPeriod.find(unit.teaching_period_id).period
      #   }
      # end
      [
        {
          unit_id: 1,
          unit_code: "SIT100",
          period_name: "T1",
          period_year: "2018"
        },
        {
          unit_id: 2,
          unit_code: "SIT101",
          period_name: "T2",
          period_year: "2018"
        }
    ]
    end

  end
end
