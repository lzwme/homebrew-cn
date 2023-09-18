class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v4.1.0.tar.gz"
  sha256 "b9dd1b41c76d7bf8a5d96ff0c70f4ee12045ee69b34fad6302d0df5d14c7d4c3"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "22248c350eea9f4abca783e9333b54acc8f970ba708f3d2ca739d667f0ec6516"
    sha256                               arm64_monterey: "8d4548b4760a52c2e43c997045ed68780cf957d8e41339d3fbdebf535f4c1e72"
    sha256                               arm64_big_sur:  "fdec263fc19d22a606bba7fb4f3893469ea52e15311a7c7c5619c256ac7a6a1e"
    sha256                               ventura:        "7c25fd4a2aab0f5f25cf18aa7c001d3ba692f405b1d96d3ec8e82cdf105e3579"
    sha256                               monterey:       "d1e0dc6b61ddc1199eb603d2223a1bded18d2bf4f0de01d4aa87348236faa129"
    sha256                               big_sur:        "1f6718fdfd76d40f3d0e59b12f2adba2060fbe372a5666c23a1e54a083112357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a08e2b7ed921370722b7d2da801b978f6378d71d22b9aab6d1b2f7a1b1c39e"
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