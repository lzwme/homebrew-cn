class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "d206a76b3bc103a0c5187f973943cbd8339995a289f62a237a0e658ecb2d0743"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "e3254490bbec52ab096af6c6cd05960228eb152f3a2b9f9a7e0cfe08ed2b6d71"
    sha256                               arm64_ventura:  "054d114837ff141197db25115bce61fb0de831eb160e3e8ac1dc90461fc69cdb"
    sha256                               arm64_monterey: "e9f0f7b6afd8a5ae45125bc799f5d8ba008b278094fa76aef4ccba7ffc121b4f"
    sha256                               sonoma:         "0601d8429830b760677682130610276fa02b05f7bd7cd9db9d26eec85869f74b"
    sha256                               ventura:        "777ef87a39b6bc2bf86eed6f9539382611532ef7be73b5c939579e02f0ee8117"
    sha256                               monterey:       "68305b82850f9b723b81175755840edc4bbf9ac97ecca978cf9c4fdaedc84d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8357c347efb2707daa3a12aa0730eb4dfee8e5d26bf771e4696ad7064563eada"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end