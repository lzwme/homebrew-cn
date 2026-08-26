class TerminalNotifier < Formula
  desc "Send macOS User Notifications from the command-line"
  homepage "https://github.com/julienXX/terminal-notifier"
  url "https://ghfast.top/https://github.com/julienXX/terminal-notifier/archive/refs/tags/3.0.0.tar.gz"
  sha256 "10dea2da3a698e0a5119400c0500ff82ce14ddb140e7fea0ce68bf57719620ed"
  license "MIT"
  revision 1
  head "https://github.com/julienXX/terminal-notifier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733ea72832c62612ac0335503d835e0a521efe2b33aad5855452ee5335370878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1646eb25d792898d62ff2648078802176899334154b65709c54b8cf660c176b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd368f12177ea05698c2184ce502d7471e0a3a51ea2632ea1b059580cec9cbca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e4464fdff9010c644785dcf51a1be3ce443848f0303271a653a33e9a25022ad"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    prefix.install "build/Release/terminal-notifier.app"
    bin.write_exec_script prefix/"terminal-notifier.app/Contents/MacOS/terminal-notifier"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/terminal-notifier -help")

    # check the signature and not just the help output.
    app = prefix/"terminal-notifier.app"
    system "/usr/bin/codesign", "--verify", "--strict", app
    assert_match "fr.julienxx.oss.terminal-notifier",
                 shell_output("/usr/bin/codesign -dv #{app} 2>&1")
  end
end