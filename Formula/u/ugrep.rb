class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://ghfast.top/https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.0.tar.gz"
  sha256 "8563eb731f206187c6a0e0652be1cdb8afdf368ddb2e48ba2b25c0b06d8b0aa6"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "66bf444861aead007d6eb333072a2658bb2323ce8870cb0882e44735bec9538c"
    sha256 arm64_sequoia: "5a19e79c3032ced6f355583140537d641c2d2b4063267242579f8e2b958b1dac"
    sha256 arm64_sonoma:  "f1ff3fda3a5664a5ff3415914cf2023314f925c0a109d55e7785cdecbca0a013"
    sha256 sonoma:        "488ade69ecb13db5c129b9e13c2a5e8e70a3c9271bcc685d7a89b311a453cc13"
    sha256 arm64_linux:   "2a453bde2fa34155b51d0fdeda0aacbb16661c6f1780e3188bf87cbbae7d1a48"
    sha256 x86_64_linux:  "944bdcf920b29b9ab17adf3dba115a3aa297d5afe50d8040f9ba61a0f7b5a348"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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