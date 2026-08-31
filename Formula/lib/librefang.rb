class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://ghfast.top/https://github.com/librefang/librefang/archive/refs/tags/v2026.8.30.tar.gz"
  sha256 "2f2cac0d2d3645d0a27e5ee6b82b0ca7a9cfc90222f0ade35efebbc8c85f5bbf"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "29ad416c758b7bf5be2d1783da6079c9d5634495b4105ab886c345c9cf7fbd18"
    sha256 cellar: :any, arm64_sequoia: "e30a4893bbc248e835980c0589ad5586842ae86217ea616215fad0ff678a509c"
    sha256 cellar: :any, arm64_sonoma:  "04f42575dce04173d41568f692ca6f9086f50ab962beabb44ef14d1db56bfdd4"
    sha256 cellar: :any, arm64_linux:   "5a6153b41afb79c14766ca35bb0997bfbfb519497d82f4b13ad04f7424391cfe"
    sha256 cellar: :any, x86_64_linux:  "df17314ddfd805b766541ee81432c587712c7cf412326b9f55536454f17796ec"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end