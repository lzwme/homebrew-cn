class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.15.0.tar.gz"
  sha256 "cbfdc0405a2d02816ef659721356d791a46d11d8e46e6b97026bf2458728c4fb"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "995babe3c24489edcdaaecf8a06810cf0aa3a8fb44cb86b6349e2200adbdb097"
    sha256 arm64_monterey: "9aeadcde68df1c91e8628f8c1ca6442dc2d8d9145966a45ee3eb2e34f9fe63e6"
    sha256 arm64_big_sur:  "8527a5d0507373ac76cb5e929f92d57457092effd631b937ecc9faadccae023c"
    sha256 ventura:        "b12e99895cd1ae47259f7448abc4b77b55b3c8613ce48408ea06a89d8bfc2946"
    sha256 monterey:       "0ec245779d062fe8a485e310d152bca36cd43d98405043c5d9acc431d84816a1"
    sha256 big_sur:        "8ce37660bd15256b9b83a39c6b054e0d5524d4460d6af76d6a582ca1468b96e7"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end