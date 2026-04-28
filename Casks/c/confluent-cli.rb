cask "confluent-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "4.59.0"
  sha256 arm:          "d8c7f6d080d958b9691704949aa2da059bd15836575fcea9fd5178dc6216a713",
         intel:        "ca160000e10b63968e680905ccd030ef28225075f5be59c04f005aa07867aa63",
         arm64_linux:  "c8bc2faa5b21012c91e3736c0decf90c9b90eb5eedbf07954a0ae289a05776ef",
         x86_64_linux: "67e864d7024a89604853395c54f1ec075e8f01d22b194b842ff0197d5588d980"

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