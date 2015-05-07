Ads.configure do |config|
  config.renderer = lambda { |options|
    tag(
      :img,
      src: "http://placehold.it/#{350}x#{150}&text=Adsense"
    )
  }
end
