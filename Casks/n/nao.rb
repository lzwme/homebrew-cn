cask "nao" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "0.1.37"
    sha256 "0fbb5e012b778c2b29e97a2d5b71d9352077f6ea86def48225ae2badcfe22803"
  end
  on_intel do
    version "0.1.32"
    sha256 "1fd4cc089fbd0e1de0f2bcea0ca7b9d61a01a5e16fea493402aaff059a18d140"
  end

  url "https://storage.googleapis.com/nao-releases/nao/darwin-#{arch}/#{version}/nao.#{arch}.#{version}.dmg",
      verified: "storage.googleapis.com/nao-releases/nao/"
  name "nao"
  desc "AI code editor for data"
  homepage "https://getnao.io/"

  livecheck do
    url "https://storage.googleapis.com/nao-releases/nao/darwin-#{arch}/releases.json"
    strategy :json do |json|
      json["currentRelease"]
    end
  end

  depends_on macos: ">= :catalina"

  app "nao.app"
  binary "#{appdir}/nao.app/Contents/Resources/app/bin/nao"

  zap trash: [
    "~/Library/Application Support/nao",
    "~/Library/Caches/com.nao",
    "~/Library/Caches/com.nao.ShipIt",
    "~/Library/HTTPStorages/com.nao",
    "~/Library/Preferences/com.nao.plist",
    "~/Library/Saved Application State/com.nao.savedState",
  ]
end