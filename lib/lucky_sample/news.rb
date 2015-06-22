require 'yaml'

module LuckySample
  module News
    def news_filepath
      File.expand_path('data/news.yml', ROOT_PATH)
    end

    def news
      @news
    end

    def load_news
      @news = YAML.load_file(news_filepath) || []
    end

    def save_news
      File.write(news_filepath, news.to_yaml)
    end

    def new_article
      article = {
        timestamp: Time.now.to_i,
        title: '',
        body: ''
      }

      news << article
    end

    extend self
  end
end
