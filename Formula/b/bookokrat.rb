class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "0d440729b1c1fdc07b53ac1bf8a2b4f0975c24f87fa48b5f2a36c58aaea740aa"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b537f9ba180c53f19dd60655ffc59065ea6360bc784686feaca08c459808a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92813376032dd502b4dcc19693e667bf0eec94bcdaa944b8bb694626ae5b639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6403c68afad57cd17b37f0e017e9276b28e3fd239043680bdc30ce3654b27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7153c20939843b512124070c466e3e9e436474ef51e8365adf37f7a60e26490c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45de5330db079a0daacb2d715622f98666c435137f551c7e986e2e21959e7deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6883c02589b8fa0dfa25c97e8d1d7a1652143c0fd7dab9c457261e6e9e000207"
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