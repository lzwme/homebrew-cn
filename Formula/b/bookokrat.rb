class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "c4871e93ce57ee32693c2f6358782dedc920cf139a266ae26f3d958202854284"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1445191827e9188f0c956ccee8017bfa85f600c0b250dbff4905553654084258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d743a9dd168477fd0738c1ac430ab105873c64f911884ad6bd79ae88912d5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9be2deec0be9ad8a40359a557f1b7485e2ee11dcc6df67b1b514b715e10cd59"
    sha256 cellar: :any_skip_relocation, sonoma:        "665c7393c67d3e5b2abd51f008a8305eb9864e5b24380aea05f7f165a6d79740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4aea92f788636f0bf126877965e46e6e794625d93ec70bfbf6e06065b2d2bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6574b6e96be71dacce9490090bdcc8bd15f4185acd954596be0432c5358e815"
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
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/bookokrat"
    else
      testpath/".config/bookokrat"
    end
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end