cask "radio-silence" do
  version "3.2"
  sha256 "dbbab3dacee6fc95a65a9d1af1163c40703a2310d098f997a6ca3f36778d4485"

  url "https:radiosilenceapp.comdownloadsRadio_Silence_#{version}.pkg"
  name "Radio Silence"
  desc "Network monitor and firewall"
  homepage "https:radiosilenceapp.com"

  livecheck do
    url "https:radiosilenceapp.comupdate"
    regex(%r{href=.*?Radio_Silence_(\d+(?:\.\d+)*)\.pkg}i)
  end

  pkg "Radio_Silence_#{version}.pkg"

  # We intentionally unload the kext twice as a workaround
  # See https:github.comHomebrewhomebrew-caskpull1802#issuecomment-34171151

  uninstall early_script: {
              executable:   "sbinkextunload",
              args:         ["-b", "com.radiosilenceapp.nke.filter"],
              must_succeed: false,
            },
            launchctl:    [
              "com.radiosilenceapp.agent",
              "com.radiosilenceapp.nke",
              "com.radiosilenceapp.trial",
            ],
            quit:         "com.radiosilenceapp.client",
            kext:         "com.radiosilenceapp.nke.filter",
            pkgutil:      "com.radiosilenceapp.*"

  zap trash: "~LibraryApplication SupportRadio Silence"
end