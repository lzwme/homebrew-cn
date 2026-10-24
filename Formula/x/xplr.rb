class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://xplr.dev"
  url "https://ghfast.top/https://github.com/sayanarijit/xplr/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f4a6c8c550d240813fbf5683de98f6f7a519e549d6370a3fc777a93a88396f66"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7caabd9744cb8d6dd227cd9c896feaa0783625b6b401dc2cba8f3fa96e566c8f"
    sha256 cellar: :any, arm64_tahoe:       "e5b183331d0c10609a4e36921909a0247e413d534a4be9cbe0d072851baecf03"
    sha256 cellar: :any, arm64_sequoia:     "89523214ba7c8f5ddfa9e575baf17819c49e5b4bf22f0ff56c2ddaca538cb7c8"
    sha256 cellar: :any, arm64_linux:       "eda0200a5cd8d50afafb136136bb63a4a6e5f8f235dd5433e807d867549a8a9c"
    sha256 cellar: :any, x86_64_linux:      "d1169107210462d0d7ee1d4c74b3c7aaad7a005ce92b188210ccba4f39d80abd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert Utils.binary_linked_to_library?(bin/"xplr",
                                formula_opt_lib("luajit")/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end