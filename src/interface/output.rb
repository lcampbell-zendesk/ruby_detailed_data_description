module Interface
  module Output
    def self.format_results(results)
      results.map { |r| row_as_table(r)}.join("\n--\n")
    end

    def self.row_as_table(row)
      widest_key_width = row.keys.map(&:length).max
      row.map do |key, value|
        "%#{widest_key_width}s: %s" % [key, value]
      end.join("\n")
    end
  end
end
