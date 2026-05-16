class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "19b74f8289e7311287b1b951da623255110394c8a8424145d41c8ec814946270"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f58aaaa9e3c4152e0cdf0d0b82b577aead9adeb2823b44685d1dd93d0f72d9a"
    sha256 cellar: :any,                 arm64_sequoia: "fab162ba7f563a512e7194ba5f017edf560e6411feeab29c0fdc794c1d45f037"
    sha256 cellar: :any,                 arm64_sonoma:  "510dd71ce417314b4deb780af0fa41b046b6450757041891952be093b5ccd78f"
    sha256 cellar: :any,                 sonoma:        "07b074edc604e802699bc4c3c94c456fc9b987def8fbc234429f8952921bc5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0022a5592497f9b6d52f315d5997a65bc0d98d8f1be11a76892a7f4064ec2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4c7e0cede480a2c77aeced486a5f1de546105153cd3b120df4fe23a870831f"
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