class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "71a8b91ec59193cbca3f9f2182d8dd5a3717501c311d68a7093f07a8723a6b87"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aea504dc84c4d93682d514896a7dec82b46dcfebb6de70230407d68e08fa59d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9183d1235ad341146851f7c3d0c213282abdce86b54a0e251ac65584dd406cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1b0da3bc406af1e59befc2ee5587bacd623627ce2c3e849741fb4144480a21d"
    sha256 cellar: :any,                 arm64_linux:       "139ff8657dc540ccf93d68f03c62c798d134fc9abda8af177a8e18853211c16d"
    sha256 cellar: :any,                 x86_64_linux:      "266d61d6433a8d8ad344fb8bdd38646df89bbdfe76faf1a6fd7781abc1c576c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

    log_prefix = if OS.mac?
      testpath/"Library/Caches/bookokrat"
    else
      testpath/".local/state/bookokrat"
    end

    assert_path_exists testpath/".config/bookokrat/config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end