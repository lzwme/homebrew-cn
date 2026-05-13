class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "0af450ed7c2e0108f06b52e892a6143835fb6f08fbb28d34fb59e628eff4a356"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e690c9658a6ecdb8360541d8212a3dc792201f00ccb355462ce3a51383a09cd"
    sha256 cellar: :any,                 arm64_sequoia: "40b56a97279748f3fb22d031db51addff222a0ce92f4696c82df7a0f474b63f4"
    sha256 cellar: :any,                 arm64_sonoma:  "717c57bd454d70d19af0de6e52d806baa8c4f1693144306cf3d709458671f42a"
    sha256 cellar: :any,                 sonoma:        "c31bcd584a12a843690197fcf005bffa915af21fca898c60f18437b6ec5d522e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b06187d59cff42db16cb9682d60907774ecf7e6562007dd06636a525438577da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a295b182150fe05bf3fedecfc639dff9e9adcf2d0915bad770b3683724511081"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end