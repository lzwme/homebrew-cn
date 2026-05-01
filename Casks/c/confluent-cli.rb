cask "confluent-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "4.60.0"
  sha256 arm:          "64043d4637c63a9c964925c6ce288422ac520af12442c8a8f7a2feb511d763ae",
         intel:        "ef3849fd15d00f2c992c74c024717285543714e1b2ecce27983d9ad959748957",
         arm64_linux:  "a668a430e7995c88bbfca6c0d42d5af1d95c3861192c2e20fd0be7554fc03885",
         x86_64_linux: "d869a17ed434c633f553edcbd0a6936ab757bc8254d48a46d66a623fa05cc578"

  url "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/#{version}/confluent_#{version}_#{os}_#{arch}.tar.gz",
      verified: "s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/"
  name "Confluent CLI"
  desc "Enables developers to manage Confluent Cloud or Confluent Platform"
  homepage "https://docs.confluent.io/confluent-cli/current/overview.html"

  livecheck do
    url "https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=confluent-cli/archives/&delimiter=/"
    regex(%r{confluent[._-]cli/archives/v?(\d+(?:\.\d+)+)/}i)
    strategy :xml do |xml, regex|
      xml.get_elements("//Prefix").map do |item|
        match = item.text&.strip&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  binary "confluent/confluent"

  zap trash: "~/.confluent"
end