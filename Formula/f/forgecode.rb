class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.11.tar.gz"
  sha256 "da4cbda63ec2dd173e02ce0232c3cacdf05cb841fedd56bd9d967231aa750f76"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24e0bee64a2abcddaa68a04748e7dc286911703d4b814eb976ca75d270a94f4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41629ee4d05f7bed9c3dc7cd9abf78c8d0f24826a59d9e37c75e4c34cf2c6c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ae86cccece97b784fe55c069494f40dd5d5b9280c4458c4b4fe73476391986"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6f0a6b04c823149a0c41502d9d1069bdd9df4b1ebd12ecbc0431344cd4c945"
    sha256 cellar: :any,                 arm64_linux:   "9e82ffc94822441a7989c05a68e832586644b5afc5ce178495404e82d3db896a"
    sha256 cellar: :any,                 x86_64_linux:  "b81a96a9e583a24b0e71cc8127b554d52522110b587bf3a95917343d2ccf6275"
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