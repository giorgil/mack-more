module Mack
  module Data
    module Factory
      
      class FieldContentGenerator
        class << self
          def alpha_generator
            @alpha_gen ||= Proc.new do |def_value, rules|
              words = %w(alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat)
              
              length = 128
              min_length = -1
              max_length = -1
              
              if rules[:min_length]
                min_length = rules[:min_length].to_i
              end
              
              if rules[:max_length]
                max_length = rules[:max_length].to_i
              end
              
              if rules[:length]
                length = rules[:length].to_i
                length = max_length if (max_length != -1) and (max_length <= length)
              end
              
              ret_val = ""
              words_size = words.size
              until ret_val.size > length do
                i = (rand * 100).to_i
                i = words_size if (i-1) > words_size
                
                ret_val += words[i]
                ret_val += " " if rules[:add_space]
              end

              ret_val.strip!
              
              ret_val = ret_val[0, length] if ret_val.size > length
              
              ret_val
            end
            return @alpha_gen
          end

          def alpha_numeric_generator
            @alpha_numeric_gen ||= Proc.new do |def_value, rules|
              words = %w(alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat)

              length = 128
              min_length = -1
              max_length = -1

              if rules[:min_length]
                min_length = rules[:min_length].to_i
              end

              if rules[:max_length]
                max_length = rules[:max_length].to_i
              end

              if rules[:length]
                length = rules[:length].to_i
                length = max_length if (max_length != -1) and (max_length <= length)
              end

              ret_val = ""
              words_size = words.size
              until ret_val.size > length do
                i = (rand * 100).to_i
                i = words_size if (i-1) > words_size

                ret_val += (words[i] + (rand * 1000).to_i.to_s)
                ret_val += " " if rules[:add_space]
              end

              ret_val.strip!

              ret_val = ret_val[0, length] if ret_val.size > length

              ret_val
            end
            return @alpha_numeric_gen
          end

          def numeric_generator
            @numeric_gen ||= Proc.new do |def_value, rules|
              n_start = rules[:start_num] || 0
              n_end   = rules[:end_num] || 1000
              
              val = (n_start..n_end).to_a.randomize[0]
              (def_value + val)
            end
            return @numeric_gen
          end

          def date_generator
            @date_gen ||= Proc.new do |def_value, rules|
              Time.now.to_s
            end
            return @date_gen
          end

          def date_time_generator
            @date_time_gen ||= Proc.new do |def_value, rules|
              Time.now.to_s
            end
            return @date_time_gen
          end
          
          def email_generator
            raise "Method not yet implemented"
          end
          
          def name_generator
            raise "Method not yet implemented"
          end
          
          def fullname_generator
            raise "Method not yet implemented"
          end
        end
      end

    end
  end
end