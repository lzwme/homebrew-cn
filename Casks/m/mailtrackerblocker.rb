cask "mailtrackerblocker" do
  version "0.8.4"
  sha256 "30e36c5fad061a86779d6c412a6225b29efdfdced06e3bb19c3795232dfff4ef"

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