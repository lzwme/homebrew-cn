class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.19.0.tar.gz"
  sha256 "6095b01d14031ec80458728361b31b65dd1b5cd68b73e18db8f9f26c57d0c361"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "37e3b9484a6309b5cd6a9c1f65e5c5f96619062f1032076a617d976967fa77b6"
    sha256 arm64_ventura:  "e2e48cd6ccea8248e011f554adf2f8e1d37d691cc1c8ab7fea64f67f6552d04a"
    sha256 arm64_monterey: "8522a89378499d89516b2fd02be9fb68152365b76ef7254548dc2ea98d43899a"
    sha256 sonoma:         "fbc60fbfd5a1bea12fae5e3c4e7f526b4dfa100c57c4eaca5937252874bf8a93"
    sha256 ventura:        "17b64e69fb2b7942b088bce9cb67eeafd09870103ef5d9d3616f53360e8a8105"
    sha256 monterey:       "32e3189a2591d3ce5af28ceb83dc1e34c80a87c27448960ed5c4131a690367c1"
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