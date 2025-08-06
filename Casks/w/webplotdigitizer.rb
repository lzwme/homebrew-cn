cask "webplotdigitizer" do
  arch arm: "apple-silicon", intel: "darwin-x64"

  version "4.7"

  on_arm do
    sha256 "e5ea8537c7809cce52c4d841ae0be89436f651924c10ab944507bb0ccd3febdb"

    app "WebPlotDigitizer.app"
  end
  on_intel do
    sha256 "1175eb93a78844e6cb9153856bb3a648c190eebc20347250eb23c4d049507fbf"

    app "WebPlotDigitizer-#{version}-#{arch}/WebPlotDigitizer-#{version}.app"
  end

  url "https://apps.automeris.io/downloads/WebPlotDigitizer-#{version}-#{arch}.zip"
  name "WebPlotDigitizer"
  desc "Extract numerical data from plot images"
  homepage "https://automeris.io/WebPlotDigitizer.html"

  deprecate! date: "2024-06-10", because: :discontinued
  disable! date: "2025-06-11", because: :discontinued

  depends_on macos: ">= :catalina"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.webplotdigitizer.sfl*",
    "~/Library/Application Support/WebPlotDigitizer",
    "~/Library/Preferences/com.electron.webplotdigitizer.plist",
  ]
end