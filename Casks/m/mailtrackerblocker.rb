cask "mailtrackerblocker" do
  version "0.8.5"
  sha256 "71c59da4c3d489351e3043d660ca62b2f6a145a8fd477c9e224e8418ef28a919"

  url "https:github.comapparition47MailTrackerBlockerreleasesdownload#{version}MailTrackerBlocker.pkg",
      verified: "github.comapparition47MailTrackerBlocker"
  name "MailTrackerBlocker"
  desc "Email tracker, read receipt and spy pixel blocker plugin for Apple Mail"
  homepage "https:apparition47.github.ioMailTrackerBlocker"

  deprecate! date: "2024-04-22", because: :moved_to_mas

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

  zap trash: "~LibraryContainerscom.apple.mailDataLibraryApplication Support" \
             "com.onefatgiraffe.mailtrackerblocker"
end