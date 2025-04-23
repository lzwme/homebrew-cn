cask "mailtrackerblocker" do
  version "0.8.6"
  sha256 "96dc1e4386386362b204c6e0e40055c86766dfe12ef74c8ae3d30d11922085ea"

  url "https:github.comapparition47MailTrackerBlockerreleasesdownload#{version}MailTrackerBlocker.pkg",
      verified: "github.comapparition47MailTrackerBlocker"
  name "MailTrackerBlocker"
  desc "Email tracker, read receipt and spy pixel blocker plugin for Apple Mail"
  homepage "https:apparition47.github.ioMailTrackerBlocker"

  deprecate! date: "2024-04-22", because: :moved_to_mas
  disable! date: "2025-04-22", because: :moved_to_mas

  auto_updates true
  depends_on macos: "<= :ventura"

  pkg "MailTrackerBlocker.pkg"

  uninstall_postflight do
    if system_command("ps", args: ["x"]).stdout.match?("Mail.appContentsMacOSMail")
      opoo "Restart Mail.app to finish uninstalling #{token}"
    end
  end

  uninstall pkgutil: "com.onefatgiraffe.mailtrackerblocker",
            delete:  "LibraryMailBundlesMailTrackerBlocker.mailbundle"

  zap trash: "~LibraryContainerscom.apple.mailDataLibraryApplication Supportcom.onefatgiraffe.mailtrackerblocker"
end