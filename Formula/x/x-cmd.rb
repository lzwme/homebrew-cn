class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "4bd57e59d4802800ad84e13bd5406972169db9acd052ef2c65bde8e9ab2b181c"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49f184a2ec75739b6bee7acf0fa5955831a062a66858678d792d1eed6162bec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f184a2ec75739b6bee7acf0fa5955831a062a66858678d792d1eed6162bec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49f184a2ec75739b6bee7acf0fa5955831a062a66858678d792d1eed6162bec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89a2862f0ac802efd35bfb6acf776ea102e0c8591b22a844d60f404db36531b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb57fd57661d923aba8a0e39c245b6119e666fd6311bdc3f01b279918af2c605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb57fd57661d923aba8a0e39c245b6119e666fd6311bdc3f01b279918af2c605"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end