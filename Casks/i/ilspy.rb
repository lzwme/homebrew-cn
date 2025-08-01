cask "ilspy" do
  arch arm: "arm64", intel: "x64"

  version "7.2-rc"
  sha256 arm:   "613ac0dc004dfef71fc805178694623a0c0f8ce7807118947b9208494f23fed1",
         intel: "480f0fe2b5dc6ad4d0df3d4c9ecd44429b97e0c8b5bac8bc99c2ac2a8e3025ff"

  url "https://ghfast.top/https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v#{version}/macOS.#{arch}.Release.zip"
  name "ILSpy"
  desc "Avalonia-based .NET decompiler"
  homepage "https://github.com/icsharpcode/AvaloniaILSpy"

  deprecate! date: "2025-07-27", because: :unmaintained

  app "artifacts/osx-#{arch}/ILSpy.app"

  zap trash: [
    "~/Library/Preferences/ilspy.plist",
    "~/Library/Saved Application State/ilspy.savedState",
  ]
end