class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.6.tar.gz"
  sha256 "39f3205a2b8b79eeb6d2eaf1727c68262010e06ba5a7c42d5164c7ed6b6822f2"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "4abfdeebfcfc638244ad02219ef5fbbdc3cceb749c976dbea8f49862718eacb0"
    sha256                               arm64_ventura:  "51ebbe1bd2d9c86b24137ecdd252045dc369e72bac8a9ceeb03cb3055dab3ebb"
    sha256                               arm64_monterey: "51acbd4695eeb55551693a2495d1ec450d3a00b44e96e010a3efe518425af886"
    sha256                               sonoma:         "7a2149a0012606ce8e8fcffe77178fbe2751409df4acf3fd899d45f9f6fa5a53"
    sha256                               ventura:        "a8575fe7b5d9f217aa8da1c9248000005e0164cd9166be519c03a422e36f1c37"
    sha256                               monterey:       "86ea0f75b95d3ed54b08269e3a2d8c30091eb2e59fadfb70f16fce4c248a1945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc071066e84c242f763efdf4b0f932aca9b67cd52b27ca312809b102df51559"
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