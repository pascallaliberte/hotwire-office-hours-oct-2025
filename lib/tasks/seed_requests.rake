namespace :seed do
  desc "Seed 2,332 request records with 88% complete status, 0% closed, and the rest mixed"
  task requests: :environment do
    total_requests = 2332
    complete_percentage = 0.88
    complete_count = (total_requests * complete_percentage).to_i
    remaining_count = total_requests - complete_count

    puts "Starting to seed #{total_requests} requests for Team 1..."
    puts "  - #{complete_count} will be 'complete' (#{(complete_percentage * 100).to_i}%)"
    puts "  - #{remaining_count} will be mixed into other statuses (#{((1 - complete_percentage) * 100).to_i}%)"
    puts "  - 0 will be 'closed'"

    # Get team 1
    team = Team.find_by(id: 1)
    unless team
      puts "Error: Team 1 not found in the database. Please create it first."
      exit 1
    end

    # Get all customers for team 1
    customers = team.customers
    if customers.empty?
      puts "Error: No customers found for Team 1. Please create customers first."
      exit 1
    end

    # Get all statuses for team 1, excluding 'closed'
    statuses = team.requests_statuses.where.not(slug: 'closed')
    if statuses.empty?
      puts "Error: No statuses found for Team 1. Please create statuses first."
      exit 1
    end

    # Find the complete status and other statuses
    complete_status = statuses.find_by(slug: 'complete')
    other_statuses = statuses.where.not(slug: 'complete')
    
    unless complete_status
      puts "Warning: No 'complete' status found for Team 1. Using first available status."
      complete_status = statuses.first
    end
    
    # If there are no other statuses, use complete for the remaining records too
    other_statuses = statuses if other_statuses.empty?

    created_count = 0
    failed_count = 0

    # Create requests in batches for better performance
    batch_size = 100
    total_batches = (total_requests.to_f / batch_size).ceil

    total_batches.times do |batch_index|
      requests_to_create = []
      batch_start = batch_index * batch_size
      batch_end = [batch_start + batch_size, total_requests].min

      (batch_start...batch_end).each do |i|
        # Pick a random customer from team 1
        customer = customers.sample

        # Determine status based on distribution
        if i < complete_count
          # This should be a "complete" status
          status = complete_status
        else
          # This should be one of the other statuses
          status = other_statuses.sample
        end

        requests_to_create << {
          team_id: team.id,
          customer_id: customer.id,
          status_id: status&.id,
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      # Bulk insert the batch
      begin
        Request.insert_all(requests_to_create) if requests_to_create.any?
        created_count += requests_to_create.size
        print "\rProgress: #{created_count}/#{total_requests} requests created (#{(created_count.to_f / total_requests * 100).round(1)}%)"
      rescue => e
        puts "\nError creating batch: #{e.message}"
        failed_count += requests_to_create.size
      end
    end

    puts "\n\nSeeding complete!"
    puts "Successfully created #{created_count} requests for Team 1"
    puts "Failed: #{failed_count}" if failed_count > 0

    # Show final distribution for team 1
    puts "\nFinal status distribution for Team 1:"
    team.requests.joins(:status).group('requests_statuses.slug').count.each do |slug, count|
      percentage = (count.to_f / team.requests.count * 100).round(1)
      puts "  #{slug}: #{count} (#{percentage}%)"
    end
  end
end

