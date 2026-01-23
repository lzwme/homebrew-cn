class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.xyz"
  url "https://ghfast.top/https://github.com/hanebox/ekphos/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b0d7a902902d08e1dfc75325241f3dfa8f82700870dec8c9b3cdf011814adce2"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5fb5bea27dd82e9a34037863e9ae195c8b707d950440f0d4088eb34ef21af34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3484cee003184b1c2361479512b2088bf8f06ffd962c872a30e81bd0b0a77670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa98ca9c574de40134ffb292fe96a11de07d0af74bb38d30ddb1986f1e843fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfadd8a174923771f61340aa296180e401a93bd61c3ae980a7541fcc600faa66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c338d46fe82075436b8beab0a25e716ad043577d4b75a13a4d11f9a4056f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0412f843a3ad09e95ca4d255734e9fcf371c57fa7d8803112f7d55858923ef28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end