class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://ghfast.top/https://github.com/librefang/librefang/archive/refs/tags/v2026.7.11.tar.gz"
  sha256 "3d75bbceca2185029bcca13888d68d86be56500525fc22e45aa5c06042f5a1a7"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "98bf67eb3dbf1bf660399cf486736cdf681069faa6c13411ecd0abcfa6430c64"
    sha256 cellar: :any, arm64_sequoia: "ac7fe78e4647cb890829af87d0d1caf03064df309cab999be4e07e278b3812ea"
    sha256 cellar: :any, arm64_sonoma:  "bba68efd462fa6a9b252e6587fe3e37cb34f1dabd570ce743337842e1363ce60"
    sha256 cellar: :any, sonoma:        "2cb6c2a62bf72437528f77e9d10c29a5d64bbb8a6b41712e898ab2054b6b58d6"
    sha256 cellar: :any, arm64_linux:   "286a5318c98375403866562a571deedf1de97ec032d7a2b0f02c892d2d2da301"
    sha256 cellar: :any, x86_64_linux:  "b85eade8ca4084f87ed0bbcf806199c791979ca3cb6027d7af13ee47e00f122c"
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