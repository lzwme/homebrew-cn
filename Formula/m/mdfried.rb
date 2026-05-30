class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "ebd37746d11135b5db83b03d6b5106578655c9544123069b53bcef6db9f0d744"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9f19203c875ba225c80f17d1adac38623c69ac9f2998764223aa8df9f9c634ac"
    sha256 cellar: :any, arm64_sequoia: "86eece20e774c598b7daf5d63f83fce3625877ba85975e442b37c2de13a9de5f"
    sha256 cellar: :any, arm64_sonoma:  "f471ab343d187b45ec233149df455b5903cef2a0d5467926cbdb4acd84bba542"
    sha256 cellar: :any, sonoma:        "5aefc6c728255b297e1093ed91aa9963692a1c5b3817ae952ffb665176806f0c"
    sha256 cellar: :any, arm64_linux:   "b07f3fa3bfaef79ecf6cbc225073265ca92bd4b95bd92bdf5f4399311afa6653"
    sha256 cellar: :any, x86_64_linux:  "3539a461cf097db3cf45ace06a9b77cec8a7ef1b6c42be3dbe7a5c42e77d16fd"
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