cask "kekaexternalhelper" do
  version "1.2.0,1.4.4"
  sha256 "6857bb22694b6f6c01a13c40953b0a04b1704acf90da414a7476be63961d9827"

  url "https:github.comaonezKekareleasesdownloadv#{version.csv.second}KekaExternalHelper-v#{version.csv.first}.zip"
  name "Keka External Helper"
  name "KekaDefaultApp"
  desc "Helper application for the Keka file archiver"
  homepage "https:github.comaonezKekawikiDefault-application"

  # We can identify the version from the `location` header of the first
  # response from https:d.keka.iohelper but we need to be able to either not
  # follow redirections (i.e., omit `--location` from curl args) or iterate
  # through the headers for all responses (not the hash of merged headers,
  # where only the last `location` header is available).
  livecheck do
    skip "Cannot identify version without access to all headers"
  end

  app "KekaExternalHelper.app"

  zap trash: [
    "~LibraryContainerscom.aone.keka",
    "~LibrarySaved Application Statecom.aone.KekaExternalHelper.savedState",
  ]
end