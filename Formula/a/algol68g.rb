class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.11.1.tar.gz"
  sha256 "53004c643832b0b67d83aadf7392310a06f8a3ecdd98f413ece437b7970befa8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2fd900c272e2cf270db4b458d8f8029672387279ce3a394e675c157ccb5780ee"
    sha256 arm64_sequoia: "a22caf728b06a19dcc78ad107b1e99641d58377e28cc034a01c7126686f33188"
    sha256 arm64_sonoma:  "03a56d25eedf3ffc1bd8b50166a060cc94b17a64aeb6105951553fece5072a58"
    sha256 sonoma:        "3332a686901a4ae43c6ce933ec40f0bb2b03e3ce826de040b4f72681cdf4e024"
    sha256 arm64_linux:   "fb94c938efb392f9a304950032fe70b34348d1648598978be4cbc01642f45f27"
    sha256 x86_64_linux:  "437e8bd88b47bb3922623424c463dd29cc0b788a3860575dbaf39da4e5ab3cd2"
  end

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end