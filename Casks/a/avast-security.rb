cask "avast-security" do
  version "15.7.5"
  sha256 :no_check

  url "https:bits.avcdn.netproductfamily_ANTIVIRUSinsttype_FREEplatform_MACinstallertype_ONLINEbuild_RELEASE",
      verified: "bits.avcdn.netproductfamily_ANTIVIRUSinsttype_FREEplatform_MACinstallertype_ONLINE"
  name "Avast Security"
  desc "Antivirus software"
  homepage "https:www.avast.com"

  livecheck do
    url "http:mac-av.u.avcdn.netmac-av10_11AAFMchangelog.html"
    regex(%r{<h2>(\d+(?:\.\d+)+).*<h2>}i)
  end

  # pkg cannot be installed automatically
  installer manual: "Install Avast Security.pkg"

  uninstall launchctl: [
              "com.avast.hub",
              "com.avast.hub.schedule",
              "com.avast.hub.xpc",
            ],
            script:    {
              executable:   "ApplicationsAvast.appContentsBackendhubuninstall.sh",
              must_succeed: false, # A non-0 exit code may be given even if the uninstall succeeds (https:github.comHomebrewhomebrew-caskissues21740#issuecomment-224094946).
              sudo:         true,
            },
            pkgutil:   [
              "com.avast.AAFM",
              "com.avast.pkg.hub",
            ]

  zap trash: [
    "~LibraryCookiescom.avast.AAFM.binarycookies",
    "~LibraryPreferencescom.avast.avast!.plist",
  ]
end