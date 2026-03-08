class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "26e1a2c7461ac277bbf44d3dd485ce1e4c186c5805dc8d0ec629973ac1e267a0"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4dca90e72a5ed618fede3cd9fc5944fabe8c1d30b3a9738c86fd1fba876e21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e570a1521203fdc389bed8ea03b7b37ddf207634d687133e1c14a4db7822e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c063ddffc11174bfbad94e169249bd5155e0d6b9c00f5a97e5c3f2a49f3db41"
    sha256 cellar: :any_skip_relocation, sonoma:        "71da6dd00376803c539a38f30b12b44e8ef7b5b2ee97f4fc3b5b05f9c8c08327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ea77dfaca6a9b9c3cc8009603acc0027fd9bc53f7bec94f40f9c9430c9f12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb63634a23c3ff71b7576985ce1b12473dd4ba04c3e56504bc4210f40be5b508"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    config_prefix, log_prefix = if OS.mac?
      [testpath/"Library/Application Support/bookokrat", testpath/"Library/Caches/bookokrat"]
    else
      [testpath/".config/bookokrat", testpath/".local/state/bookokrat"]
    end
    system "ls", "-alR"
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end