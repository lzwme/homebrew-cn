cask "private-eye" do
  version "1.1.0"
  sha256 :no_check

  url "https://radiosilenceapp.com/downloads/Private_Eye_for_OS_X_10.9_and_later.pkg"
  name "Private Eye"
  desc "Network monitor"
  homepage "https://radiosilenceapp.com/private-eye"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-06", because: :unmaintained
  disable! date: "2025-07-06", because: :unmaintained

  pkg "Private_Eye_for_OS_X_10.9_and_later.pkg"

  # We intentionally unload the kext twice as a workaround
  # See https://github.com/Homebrew/homebrew-cask/pull/1802#issuecomment-34171151
  uninstall early_script: {
              executable:   "/sbin/kextunload",
              args:         ["-b", "com.radiosilenceapp.nke.PrivateEye"],
              must_succeed: false,
            },
            launchctl:    "com.radiosilenceapp.nke.PrivateEye",
            quit:         "com.radiosilenceapp.PrivateEye",
            kext:         "com.radiosilenceapp.nke.PrivateEye",
            pkgutil:      "com.radiosilenceapp.privateEye.*"
end