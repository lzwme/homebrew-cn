class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://ghfast.top/https://github.com/prasmussen/chrome-cli/archive/refs/tags/1.10.3.tar.gz"
  sha256 "3ab0cb9ffa898bacd64937431791775af6711bffd7fa8b5660a1aa108bb46a0f"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae77de16dfdd91be87e6dda905231a8891089e8ff3db5492a051dc5bffcfc4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeabd9e39b248e509bc92fd6666123a43900666eb2daa93fc4033019c62629ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba05833609b8245999aa0f8a3f3c79d2748325b88bdce97c3349b38f18355e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe783bbe744c5e1931b400bd13b7c7af0a59275ee62b70205edd083b805901d"
    sha256 cellar: :any_skip_relocation, ventura:       "063f7a6dc767f44ce574e26d5f3e38fb2ae93a6d884bb4d58c72cbaf3c1c7983"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Release builds
    xcodebuild "-arch", Hardware::CPU.arch.to_s, "SYMROOT=build"
    bin.install "build/Release/chrome-cli"

    # Install wrapper scripts for chrome compatible browsers
    bin.install "scripts/chrome-canary-cli"
    bin.install "scripts/chromium-cli"
    bin.install "scripts/brave-cli"
    bin.install "scripts/vivaldi-cli"
    bin.install "scripts/edge-cli"
    bin.install "scripts/arc-cli"
  end

  test do
    system bin/"chrome-cli", "version"
  end
end