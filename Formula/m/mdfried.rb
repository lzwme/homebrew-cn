class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "615707f302d8ab1fe9edca63117ec3d98ff8b0f2de86aa0341edc50a51e655a6"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39529170b6291ea686cea77c9353acdba96f6b0b5c4e2972c7cb0f8c1fb94031"
    sha256 cellar: :any,                 arm64_sequoia: "f2c46c33b864eb62e2853b79e7333e1972f6ed0c6fe7b63387122fc0b07827c4"
    sha256 cellar: :any,                 arm64_sonoma:  "24f02bfa5d21f82415f044b913b30769d676b7843e0ec0bedbb77128bfdf1106"
    sha256 cellar: :any,                 sonoma:        "d82f153a4519e79eeba0ff7b8d86f23c3affcffcb86db31136bb7f844ec6c548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da688f13fa977994dfd29482dc736ee1179126dacedbb6de1dc5c779eb5f14b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff116e9f3c8ede647699fc698d170077ca26bcba59e709e398affe964b00d00"
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