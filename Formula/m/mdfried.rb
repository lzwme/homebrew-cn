class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "e49fb7cf7fa5d88b0b1147094c9b1eb541bf7b7bf8f314d1d2efab47755dd092"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ae3a106e6a79d8fa52fb613e811ab7bdb3ed3b419b11adada247e1665cf7c97"
    sha256 cellar: :any, arm64_sequoia: "20e6760f72d1830af9a8773ae5abda9a5ab3a7c48530a39830780063c6e8ed97"
    sha256 cellar: :any, arm64_sonoma:  "b022b1671533e4e79994dc26d32cc70cb686931161e5a673b7cbf4d9eca67c3a"
    sha256 cellar: :any, sonoma:        "f17ede50daab8f784bcb450441f132442ca8c98a1ac09a3f821fd644fe420738"
    sha256 cellar: :any, arm64_linux:   "efd5a197521d1c44ed26f737fed8c71719d5f2ef96277839c57d41d6cd6c6da3"
    sha256 cellar: :any, x86_64_linux:  "b8b70ec33d3018bc500611e331ece28ca22200c4d6fb1c768cf886a27603e688"
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