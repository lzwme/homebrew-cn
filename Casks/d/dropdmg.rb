cask "dropdmg" do
  version "3.7"
  sha256 "63568b7194334d05052ca1ac94c2d26e9f00d6b51a0d39213f484352a4c6d233"

  url "https://c-command.com/downloads/DropDMG-#{version}.dmg"
  name "DropDMG"
  desc "Create DMGs and other archives"
  homepage "https://c-command.com/dropdmg/"

  livecheck do
    url "https://c-command.com/versions.plist"
    strategy :xml do |xml|
      item = xml.elements["//key[text()='com.c-command.DropDMG']"]&.next_element
      next unless item

      version = item.elements["key[text()='Version']"]&.next_element&.text
      next if version.blank?

      version.strip
    end
  end

  auto_updates true

  app "DropDMG.app"

  zap trash: [
    "~/Library/Application Support/DropDMG",
    "~/Library/Automator/DropDMG.action",
    "~/Library/Automator/Expand Disk Image.action",
    "~/Library/Caches/com.c-command.DropDMG",
    "~/Library/HTTPStorages/com.c-command.DropDMG",
    "~/Library/Logs/DropDMG",
    "~/Library/Preferences/com.c-command.DropDMG.plist",
  ]
end