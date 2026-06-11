class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.7.tar.gz"
  sha256 "e18ad558257c240c3b897b13176317c659117e11bfd766051c11794d98b87b74"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "942c42ac0d9ec7cbfecbbf9076a61acb13c9ba02eda6189cdb3f8ea803a657d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d16a33646ea4c25498c03a2522a5b58f2d4dc406531c30a378f02eeb9b3c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bde550a10605e069790f6343c60a72abcf483c040cb0d12ebdbd3491d313efb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e1ca9dd51747ba177ec23d5b5caa72c335c5deb54a2444114a799f6aadae0e8"
    sha256 cellar: :any,                 arm64_linux:   "adf156232f8c535889b5adf764e5dd7fb2adfabd71824e2450c1b47c0254d38a"
    sha256 cellar: :any,                 x86_64_linux:  "858e9019837fbeb441ccab60adae0ab817643aa2ec3e2b14baf7c52d122bf8f0"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end