cask "symboliclinker" do
  version "2.2"
  sha256 "80257a720531d448c6034e74a494e68e82f293af14ef56edbb7379f658542e84"

  url "https:github.comnickzmansymboliclinkerreleasesdownloadv#{version}SymbolicLinker#{version}.dmg"
  name "SymbolicLinker"
  desc "Service that allows users to make symbolic links in the Finder"
  homepage "https:github.comnickzmansymboliclinker"

  service "SymbolicLinker.service"

  # No zap stanza required
end