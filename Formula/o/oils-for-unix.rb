class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.27.0.tar.gz"
  sha256 "ab539162dffc1694fd5ae89c00e405cc5f7b73660159ec5b269bedea631df17d"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "043ebeb7cea64d6d87a88bd4125720825b8c08076a4e01df1424ad2118bf505f"
    sha256 cellar: :any,                 arm64_sonoma:  "1e202947e9f9c74d7356e7257836bd66633c98b26e2336ac8be3a8969343b6dc"
    sha256 cellar: :any,                 arm64_ventura: "a590a7f925138f280837ca34a067f2469098e49702e378e70da319bc5091d9e6"
    sha256 cellar: :any,                 sonoma:        "d9fd1e355a7ec5f258f2938a479c5b3c48677c7400275d7797ccd30bab7be022"
    sha256 cellar: :any,                 ventura:       "020f459af9410aab58b31ac659263b7e3c7362e6338f29aea705569f3a499964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a5d5d2911ff0f206145a0318f874a984f6a14c68c6e23f1cdfa6508f29171b"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end