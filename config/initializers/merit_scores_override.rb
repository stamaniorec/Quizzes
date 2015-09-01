module Merit
  class Score < ActiveRecord::Base
    def self.top_scored(options = {})
      options[:table_name] ||= :users
      options[:since_date] ||= 4.months.ago
      options[:end_date]   ||=  1.month.from_now
      options[:category]   ||=  nil
      options[:limit]      ||= 10

      alias_id_column = "#{options[:table_name].to_s.singularize}_id"

      if options[:table_name] == :sashes
        sash_id_column = "#{options[:table_name]}.id"
      else
        sash_id_column = "#{options[:table_name]}.sash_id"
      end

      # MeritableModel - Sash -< Scores -< ScorePoints

      sql_query = %{
      SELECT
        #{options[:table_name]}.id AS #{alias_id_column},
        SUM(num_points) as sum_points
      FROM #{options[:table_name]}
        LEFT JOIN merit_scores ON merit_scores.sash_id = #{sash_id_column}
        LEFT JOIN merit_score_points ON merit_score_points.score_id = merit_scores.id
      WHERE merit_score_points.created_at > '#{options[:since_date]}' AND merit_score_points.created_at < '#{options[:end_date]}'
      }

      if options[:category]
        sql_query += " AND merit_scores.category = \"#{options[:category]}\" "
      end

      sql_query += %{
      GROUP BY #{options[:table_name]}.id, merit_scores.sash_id
      ORDER BY sum_points DESC
      LIMIT #{options[:limit]}
      }
      
      query_results = ActiveRecord::Base.connection.execute sql_query
      results = Array.new
      
      if Rails.env.development?
        query_results.each do |result|
          results << { user_id: result.first, sum_points: result.last }
        end
      elsif Rails.env.production?
        p '---------------------------------------------------------------------'
        query_results.each_row do |row|
          p row
        end
        p 'done!!!'
        results = query_results
      end
      
      results
    end
  end
end