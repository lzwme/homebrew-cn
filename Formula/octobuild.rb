class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://ghproxy.com/https://github.com/octobuild/octobuild/archive/refs/tags/0.5.5.tar.gz"
  sha256 "10a38714b45e2443a56cf0f3b137117fd305b499e074a7f454bb9cc37de38c59"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f8848938db1998c991f8f6fe8204735fa7cb2f7446e1e60ab50d954af05400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e816742e4113a5c60cbe29f42dd7dba881a6bc139475c83c606c054bc2c60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbf9e29b8c1a47fc464ffd9f3999855f9f900d4cd5fec046d75bfa2067f29db8"
    sha256 cellar: :any_skip_relocation, ventura:        "ee6d2c51a3d5617bf30bb6d068451f06219173a0c97d43e4a80de9f4ac3902e9"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3c691304e26f24d726b31c17b3213a65f6c5b4495290d29efa3c55e71c4088"
    sha256 cellar: :any_skip_relocation, big_sur:        "34bc2ccba75a95bd84fbafdf6d22c5c1e0904f30968816f5634a0ebe310f54c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ffcdedeec3c6d6ec4715f3d66d64b1c4dc732ed6de1b38a21c7123a65ca303"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end