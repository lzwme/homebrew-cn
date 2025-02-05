cask "mailtrackerblocker" do
  version "0.8.7"
  sha256 "df917eaa4624d84a6842b896253652323f423e174e03f375816586334b2089d7"

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