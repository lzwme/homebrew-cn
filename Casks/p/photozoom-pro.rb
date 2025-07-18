cask "photozoom-pro" do
  version "9.0.2"
  sha256 :no_check # required as upstream package is updated in-place

  url "https://www.benvista.com/photozoompro#{version.major}/download/mac",
      user_agent: :fake
  name "PhotoZoom Pro"
  desc "Software for enlarging and downsizing digital photos and graphics"
  homepage "https://www.benvista.com/photozoompro"

  livecheck do
    url "https://www.benvista.com/downloads"
    regex(/PhotoZoom.*?Version\s*v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  pkg "PhotoZoom Pro #{version.major} Installer.mpkg"

  uninstall pkgutil: "com.benvista.pkg.PhotoZoom-Pro-#{version.major}.app"

  zap trash: [
    "~/Library/Application Support/BenVista",
    "~/Library/Preferences/com.benvista.PhotoZoom-Pro-#{version.major}.app.plist",
    "~/Library/Saved Application State/com.benvista.PhotoZoom-Pro-#{version.major}.app.savedState",
  ]
end