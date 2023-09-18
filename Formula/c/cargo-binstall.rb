class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8b7f91372c29c58862cadfd56b6dd439c9656c6385c9a48ffd65272ea0c28059"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93eafdb0ed2e57ec67cc6b6879db14aa3b4acd4700c931bccf900b4d6df099f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a55ec208afb4d3b86a99ebcac245cfefea791c45d7b4565fbfef940cb89d038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4870b535cfbc17d9e24aee1a7c3e39387e491658e66a8f4be5e8a86d0dc9516c"
    sha256 cellar: :any_skip_relocation, ventura:        "254d85f398d1bb3f70019f4c7b31da5295437970d391ba2b29d9c87bd3ad2e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "6663373166defe71b95a3c7deb36ed6b2337778909887ac2343fb188e1ea3541"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b9e9bca21162b7f01cb32f2cd192f912a63dcbc12385d4fdcc1f0e7825ea0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c0d37fbd4a676d18ab226ecf98d5113b545af8462afb23e37d43aa85822a1df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end