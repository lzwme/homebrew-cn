class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://ghproxy.com/https://github.com/liblouis/liblouis/releases/download/v3.24.0/liblouis-3.24.0.tar.gz"
  sha256 "02360230cf5c1fe7dcec59c41a3e74bc283548b0de637963760fa8fad9cd0c39"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_ventura:  "287aa4cf4b802fb51890d84ea2cb3cc5dabf2aa9f6104259b21fde90b88e9797"
    sha256 arm64_monterey: "1e369eec8eb042a69629959bfbc7f855cfc97e0671a9eac5bbbbb383236f70d8"
    sha256 arm64_big_sur:  "9227d5de64faed40f17c1a98d054c3f82425703dd747d0e260d4f332a7323568"
    sha256 ventura:        "b9c284c9d5e3851aa6dfda6bf26655215646175696d279098d970b132cf77a2a"
    sha256 monterey:       "2d5feeafe0fd58cb3c98b83e807ab8999462327a7b922c6e94cc0465993c47fb"
    sha256 big_sur:        "87912f235eead04e225d2a40d37b9f222c11482615f771230b4d8e6ecc77598a"
    sha256 x86_64_linux:   "8a6ba38b62b1c496307c2e598b39100d62046d5b6bffdd29d9794ff3d1b21fa1"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
    (prefix/"tools").install bin/"lou_maketable", bin/"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}/lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath/"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end