class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "2079e8f851b903477953f3ca70c9e631175a8906c9569ce6efec8b53bba6ffc5"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cea0a2a1a84a24c52e61a0536a962a3dc827454269755025dd97ab79a05df0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cea0a2a1a84a24c52e61a0536a962a3dc827454269755025dd97ab79a05df0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cea0a2a1a84a24c52e61a0536a962a3dc827454269755025dd97ab79a05df0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ca5d13c90a714734b116bbaa28a3be213eafd54221c37d9c4ac52061509590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f868734278172d97b9c8cc4ad1caf78a653ffe8ffe98c42adda8854d7d3ec0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f868734278172d97b9c8cc4ad1caf78a653ffe8ffe98c42adda8854d7d3ec0a"
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