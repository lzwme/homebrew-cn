class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "eda4e3d939a072879138f55fb1ad213f1af66414212bda6b484ae88cd2c66537"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4665e8a9713586178b922de593531f9e3125f3e61d0d170dca2a6a2a00b7a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4665e8a9713586178b922de593531f9e3125f3e61d0d170dca2a6a2a00b7a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4665e8a9713586178b922de593531f9e3125f3e61d0d170dca2a6a2a00b7a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "8602d3e643a15fa16b277cc63e7603acf6606d32d09fd8ee08b73ff68a3ad58f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e8ddc934ab5d230d646596bdd41fb431b5f43fdb6416d6150c52ae525534d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e8ddc934ab5d230d646596bdd41fb431b5f43fdb6416d6150c52ae525534d3"
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