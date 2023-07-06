require 'find'
require 'json'

def find_and_replace(directory, file_extension, search_string, replace_string, log_file_path)
  log_entries = []

  Find.find(directory) do |path|
    if File.file?(path) && path.end_with?(file_extension)
      content = File.read(path)
      
      if content.include?(search_string)
        updated_content = content.gsub(search_string, replace_string)
        File.write(path, updated_content)
        puts "Updated file: #{path}"

        # Create log entry
        log_entry = {
          file_path: path,
          search_string: search_string,
          replace_string: replace_string
        }

        # Append log entry to the log_entries array
        log_entries << log_entry
      end
    end
  end

  # Append log_entries to the log file in JSON format
  File.open(log_file_path, 'a') do |file|
    log_entries.each do |log_entry|
      file.puts JSON.generate(log_entry)
    end
  end
end

# Input Variables
directory = '/home/nishan/gurzu/gurzu.com/_posts'
file_extension = '.md'
search_string = '/img/abcabcabc/gurzu/Bug_tracking.png.webp'
replace_string = '/img/updated/gurzu/Bug_tracking.png.webp'
log_file_path = '/home/nishan/gurzu/find_and_replace_logs.txt'

find_and_replace(directory, file_extension, search_string, replace_string, log_file_path)
