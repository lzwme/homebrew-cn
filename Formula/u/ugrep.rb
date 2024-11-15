class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.0.4.tar.gz"
  sha256 "ba5382cec79d902c68eaec0d0dc63b688e2dd2d448649336ce4222c763581a9b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "60250e190e1f36f61bfb85542ae29d6097e6e09a05e869d25d8996fc6edca1af"
    sha256                               arm64_sonoma:  "bbb7173ea21118c1d778a28736002aec2c836c4a9956de830a288ce32892c478"
    sha256                               arm64_ventura: "a4ff119c746d8169a30c7345f890ca7e9db4bbb46efbf4bbc0910c355fcae3c9"
    sha256                               sonoma:        "5388154cc0c6d6f253bdb86356f4b9dbfcac3263c877b785b7ffa53ffe668ee1"
    sha256                               ventura:       "ad0d94f6a9455508df1f04e99c4432d545de68213f12e6d2a6f2ab48c680c532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625368fd8708f166b2e0800c9b14c74e1a846e083c1c36ec4e2c7c03cb6e2671"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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