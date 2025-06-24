cask "lab-app" do
  version "0.0.74,untagged-f2f7de6625ed43865c06"
  sha256 "c8073ba00c5fcc2bf724b02d257c0684a958df3a330465bef31e3f3c2122d7de"

  url "https:github.comc8rlabreleasesdownload#{version.csv.second}Lab-#{version.csv.first}-mac.zip"
  name "Lab"
  desc "React UI component design tool"
  homepage "https:github.comc8rlab"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Lab.app"
end