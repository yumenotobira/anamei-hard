# coding:utf-8

require './bot.rb'

bot = Bot.new

begin
  bot.stream.user do |status|
    #p status
    case status
    when Twitter::Tweet
      puts status.text
      user = status.user.screen_name
      # リプライが来たときの処理
      if /^@AnameiHard/ =~ status.text
        if user == "riddlyriddlaa" && status.text =~ /stop/
          bot.stop_tweet
          puts "emergency flag is on"
        end
        bot.rest.follow(user)
        puts "follow #{user} -reply case"

        text = bot.random_text
        bot.tweet(user: user, text: text, in_reply_to_status: status)
        puts "random_tweet to #{user}"
      end

      if !status.text.index("RT")
        if !(/^@\w*/.match(status.text))
          if status.text =~ /報告があります/
            text = "穴冥ハードおめでとうございます！！"
            bot.tweet(user: user, text: text, in_reply_to_status: status)
            puts text
          end
        end
      end
    when Twitter::Streaming::Event
      puts status
      user = status.source.screen_name
      if status.name == :favorite
        puts "fav by #{user}"
        bot.rest.follow(user)
        puts "follow #{user} -fav case"
      elsif status.name == :follow
        if user != "AnameiHard"
          bot.rest.follow(user)
          puts "follow #{user} -followed case"
        end
      end
    end
  end
rescue => em
  puts Time.now
  p em
  sleep 2
  retry
rescue Interrupt
  exit 1
end
