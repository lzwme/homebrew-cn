class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8b25e29b9ac5d9fba29b96e3ac733c4d0798dd0e7be8bb9826842fd34855b587"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53fc52bb66bfeaac1165c0468df257d658fb4999c646de5ff293da6babaec7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8107e9102e318936906e770c3e782b1a084024db5e152eee6020b4fcb5bedce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c714447f5647ca1f4c6df59bc61732b0189b957b935fb2aecfc129fbc53739"
    sha256 cellar: :any_skip_relocation, sonoma:        "41058ddfeff0945f8bd3564d0a9208dae0b30112437ab7659bfcfe74662415cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178b939960fdb37ed5e4ea8dadda4a09303af67af066b54a955222cd74f48b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db68803146e066862f027ff231c6138d8e526a71caab301a67bb4fd841433646"
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