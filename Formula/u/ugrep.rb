class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v4.0.4.tar.gz"
  sha256 "3985b5381c2ba02c24d71fa7754d045fe72bc31fc66c02a8375140b2f8a5e7e6"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "87eb76cac219925785dc1c86f254d19082daa5ea0ed9127cabce59b1efda617a"
    sha256                               arm64_monterey: "90f6d4b925d4f2e4d0778aee373424bd887801f685c0b655da41ab4798f2def4"
    sha256                               arm64_big_sur:  "4763f677ba8a9e109b94224db071d88e8ebdd4ad955e37cc941a2048432579a6"
    sha256                               ventura:        "e19e1b5c144d4b692cc40d2182c0c307924088d7a9ab8b44405342de7afa366f"
    sha256                               monterey:       "e4a4401c3bb434fcfbc646fa54c46b42f06ac9fbfbbf86ada48468e637af8a3a"
    sha256                               big_sur:        "b1a01f5ba4624b8303e1e2aeac30fc51548ec670d471ba23c7465ae9cc977c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fca915aadc1817ef876acaf484eff3a36bc0e3c65c7b848b5c942327c30616"
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