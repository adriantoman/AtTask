module Attask
  class Base
    attr_reader :request, :credentials, :session

    # @see Harvest.client
    # @see Harvest.hardy_client
    def initialize(subdomain, username, password, options = {})
      @credentials = Credentials.new(subdomain, username, password, options)
      raise InvalidCredentials unless credentials.valid?
    end

    # All API actions surrounding accounts
    #
    # == Examples
    #
    # @return [Attask::API::Project]
    def project
      @project ||= Attask::API::Project.new(@credentials)
    end


    def assigment
      @assigment ||= Attask::API::Assigment.new(@credentials)
    end

    def baseline
      @baseline ||= Attask::API::Baseline.new(@credentials)
    end

    def baselinetask
      @baselinetask ||= Attask::API::BaselineTask.new(@credentials)
    end

    def category
      @category ||= Attask::API::Category.new(@credentials)
    end

    def company
      @company ||= Attask::API::Company.new(@credentials)
    end

    def expense
      @expense ||= Attask::API::Expense.new(@credentials)
    end

    def expensetype
      @expensetype ||= Attask::API::ExpenseType.new(@credentials)
    end

    def group
      @group ||= Attask::API::Group.new(@credentials)
    end

    def hour
      @hour ||= Attask::API::Hour.new(@credentials)
    end

    def hourtype
      @hourtype ||= Attask::API::HourType.new(@credentials)
    end

    def issue
      @issue ||= Attask::API::Issue.new(@credentials)
    end

    def rate
      @rate ||= Attask::API::Rate.new(@credentials)
    end

    def resourcepool
      @resourcepool ||= Attask::API::ResourcePool.new(@credentials)
    end

    def risk
      @risk ||= Attask::API::Risk.new(@credentials)
    end

    def risktype
      @risktype ||= Attask::API::RiskType.new(@credentials)
    end

    def role
      @role ||= Attask::API::Role.new(@credentials)
    end

    def schedule
      @schedule ||= Attask::API::Schedule.new(@credentials)
    end

    def task
      @task ||= Attask::API::Task.new(@credentials)
    end

    def team
      @team ||= Attask::API::Team.new(@credentials)
    end

    def timesheet
      @timesheet ||= Attask::API::Timesheet.new(@credentials)
    end

    def user
      @user ||= Attask::API::User.new(@credentials)
    end

    def milestone
      @milestone ||= Attask::API::Milestone.new(@credentials)
    end

    def metadata
      @metadata ||= Attask::API::Metadata.new(@credentials)
    end

    def portfolio
      @portfolio ||= Attask::API::Portfolio.new(@credentials)
    end

    def program
      @program ||= Attask::API::Program.new(@credentials)
    end








  end
end