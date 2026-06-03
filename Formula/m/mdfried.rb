class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4abb9cc2efd1bc901e28c690d6990ec6ca03f0418716e7985b09a8b6a1e45435"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21f39ae6cd66b8040bc10ce86099f4ac4d2804d3535597e73c9b294d92eaccd4"
    sha256 cellar: :any, arm64_sequoia: "72dcbf05c42298cf0706cf1ad185143a869a7fc6eea79a145490ecb1c2af31aa"
    sha256 cellar: :any, arm64_sonoma:  "b7fcf9bb4e1fffd83ca304eec42fa7cd011e295bd16c0a36ccf243a9f36ab93b"
    sha256 cellar: :any, sonoma:        "4f4ea20ec0da20be45e241f08de2265a6629300db9f558d80a0609ca3e8eb4fe"
    sha256 cellar: :any, arm64_linux:   "31411e56745a1d24da7a20a942de916bda8d6d5aece0ec479ccb029c6dc7967d"
    sha256 cellar: :any, x86_64_linux:  "12146da90acd8f4843f0d372146b4013450d2d8bc48c2db3f3f8e84ab2e976c1"
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