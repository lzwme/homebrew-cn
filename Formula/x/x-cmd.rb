class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "606f0fc3898758541f31eea391acb8aa594ad644f164c20e502615ab5f564feb"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d534f398361c8a6a04d257b0c089ce65802814b86994ad3111786bc16b3c81a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d534f398361c8a6a04d257b0c089ce65802814b86994ad3111786bc16b3c81a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d534f398361c8a6a04d257b0c089ce65802814b86994ad3111786bc16b3c81a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bfb08ce35e996dfd1dabf9f9a26c5845d9c15c33d358c086569abf3abdbb3f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb74257dd81ff0725cd9c0465e2e50865b6870ab98dc326294c9cdccf0680d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb74257dd81ff0725cd9c0465e2e50865b6870ab98dc326294c9cdccf0680d1f"
  end

  conflicts_with "xorg-server", "x-cli", because: "both provide an `x` binary"

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