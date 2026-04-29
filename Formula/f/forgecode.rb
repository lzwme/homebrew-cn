class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.10.tar.gz"
  sha256 "2c4c846160fb1af7dfeba64ba4c566b33bd618901620501c3edb4ea960258329"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52aeea2ba3c6eb4056ad100d194b1cc5ffc7f046e7979bd0a36b0a3d9bbde3bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f12f0b3299c2275eddb6b929b217d79df6d7368d75d5de5aac7f9f99d0e8c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaffb71e5aa4a180584ea83d3ff790f7057e91068c7a2907d8bfb56bef1597a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "99cd4e4922158f046f7311c5650be87cf6776b946e749dfdffadef7bf17ca484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fafebb9fec3a5b24fb35c16b7724b4750f965a666590405f6df15ab5a43373be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66639334ab76ab461f3d3321eedbdb7dca96e6c8dffcb847735e789cf7bd1884"
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