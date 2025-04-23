class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.4.0.tar.gz"
  sha256 "d4d18db97ba0063dbc0368b30b99a625301bec77c0699bfa096867155c70fb3a"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "7ba4cc537cf43e346d2cc105ad4d47b7d280361b598d2e2114d3203fa7c8634a"
    sha256                               arm64_sonoma:  "8fbca608fe58ab9d32925adb8bc49952802083e3adab75f0bceb2c000c925ec7"
    sha256                               arm64_ventura: "c07c1d6134596f97a826946bbc0b46f84d4f72c49460d073b8522d372158c6da"
    sha256                               sonoma:        "17cbb16c6452c4282b1209cb16c52dc27bcfcc938813bacab47d165b770fdae3"
    sha256                               ventura:       "e4a7484fc85736bf0eb554a3445f008b564f5e1a9e496519df3b8f883720e7f8"
    sha256                               arm64_linux:   "4defd99709e8cf68845e410aa8ec9688f64e69a4750b5db456854cddb509fed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec25a6bdf107c7cf6d8c13a4d9bff1e5ed52d8221948b3f480c2a533a4b32972"
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