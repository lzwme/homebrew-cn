cask "freelens" do
  arch arm: "arm64", intel: "amd64"

  version "1.2.1"
  sha256 arm:   "e50774ed7803b2109b2b982723dfb5e12fa851ca5afa4d4a9bf543dabd21c5de",
         intel: "b820acd877ee19f86a86951bc460eca49b659f7df77aeedcfba7dc88c8787bf1"

  url "https:github.comfreelensappfreelensreleasesdownloadv#{version}Freelens-#{version}-macos-#{arch}.dmg",
      verified: "github.comfreelensappfreelens"
  name "Freelens"
  desc "Kubernetes IDE"
  homepage "https:freelens.app"

  depends_on macos: ">= :high_sierra"

  app "Freelens.app"

  zap trash: [
    "~LibraryApplication SupportFreelens",
    "~LibraryLogsFreelens",
  ]
end