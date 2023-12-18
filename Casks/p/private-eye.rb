cask "private-eye" do
  version "1.1.0"
  sha256 :no_check

  url "https:radiosilenceapp.comdownloadsPrivate_Eye_for_OS_X_10.9_and_later.pkg"
  name "Private Eye"
  homepage "https:radiosilenceapp.comprivate-eye"

  livecheck do
    url :url
    strategy :extract_plist
  end

  pkg "Private_Eye_for_OS_X_10.9_and_later.pkg"

  # We intentionally unload the kext twice as a workaround
  # See https:github.comHomebrewhomebrew-caskpull1802#issuecomment-34171151
  uninstall early_script: {
              executable:   "sbinkextunload",
              args:         ["-b", "com.radiosilenceapp.nke.PrivateEye"],
              must_succeed: false,
            },
            quit:         "com.radiosilenceapp.PrivateEye",
            kext:         "com.radiosilenceapp.nke.PrivateEye",
            pkgutil:      "com.radiosilenceapp.privateEye.*",
            launchctl:    "com.radiosilenceapp.nke.PrivateEye"
end