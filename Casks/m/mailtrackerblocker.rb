cask "mailtrackerblocker" do
  version "0.8.0"
  sha256 "cb7a836b1c2d7498752ca625cbb6b409ffaa2e4f182487bb85f98c4b2b2bde03"

  url "https:github.comapparition47MailTrackerBlockerreleasesdownload#{version}MailTrackerBlocker.pkg",
      verified: "github.comapparition47MailTrackerBlocker"
  name "MailTrackerBlocker"
  desc "Email tracker, read receipt and spy pixel blocker plugin for Apple Mail"
  homepage "https:apparition47.github.ioMailTrackerBlocker"

  auto_updates true
  depends_on macos: ">= :el_capitan"

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