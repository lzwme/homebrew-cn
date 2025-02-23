class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oil-0.27.0.tar.gz"
  sha256 "7461e9a7bc35e807d90dd878a1e6642167699e7bb19cf605ce075b08e0a7588c"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "697b294785828f50543a383c065c99196c22698872cf750cd5a631dadeb23f3e"
    sha256 arm64_sonoma:  "76b175019bafdb0133930f013ee47660de76e7edc50378bc04597af1d3e28380"
    sha256 arm64_ventura: "0cd75c3725dcf147a99f7335c2a1e3d043ca9c808ca2e234781b709d2e076d32"
    sha256 sonoma:        "a850521ca51a69380f6189baf11dc1929e4588ec3be4c9d0715929bd1d7387a8"
    sha256 ventura:       "5979cf10da30579477c17a0226a985d4e39577f6160021183d8b9ce7ed7f4de1"
  end

  depends_on "readline"

  conflicts_with "oils-for-unix", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    # Workaround for newer Clang/GCC
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end