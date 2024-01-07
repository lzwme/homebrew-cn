class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:github.comGeniviaugrep"
  url "https:github.comGeniviaugreparchiverefstagsv4.5.1.tar.gz"
  sha256 "81b4854b6a8bd69ff3bac616a8e5363bd020224161fa0a1af3c63da0e7a07150"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "87e17bc53321b105edd492a179a4091ee7494b96ecc491d51c441082a2e11b20"
    sha256                               arm64_ventura:  "98ae036367df17c3213f24a993c83aa94ff0521e2a1bae77fb742ee7f8788c7a"
    sha256                               arm64_monterey: "3770dee24972ab58db21ac34df7d3d77692995e32f4cc815586cc8bda7034e28"
    sha256                               sonoma:         "e468a96a7ca47a81afb4f2c21a077ca5d873831c23473faa2a3c0eb4bb359749"
    sha256                               ventura:        "00a0cf33706d451ba0620576833a09026ce9d060d8a2148c4eafd997d23b6c57"
    sha256                               monterey:       "830a1f7747754b1246815c39993c37558e0a0f9dd65c41a538a1b31583c926de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f3a8dd8452a426ad57adacdd9eafb4452669bf11767896b134a29d997d1551"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system ".configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}ugrep 'World' '#{testpath}'").strip
  end
end