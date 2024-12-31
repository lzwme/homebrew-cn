class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.1.2.tar.gz"
  sha256 "1e016791c09bfd44df14a7e00af64c10cb559fa7fd1fe3ba4b87b2c73be5e264"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "e5c0d714848b2383f1e6669201b32fbf8f854c720eaa1bd85f52531f4fac11d2"
    sha256                               arm64_sonoma:  "15a5fcc369e6f729d423cc775e9830de382b3d8a1cda314f4561e4dca5aad23f"
    sha256                               arm64_ventura: "9257bbbddf224616c40adc161366377c9e89774089aab006fe5a0a265f11a3cf"
    sha256                               sonoma:        "959f97fdbd50c3c23625d35f25320884424a391f71b21b46c2a985ab4e00fb8a"
    sha256                               ventura:       "1feb3f74adeb048fc1fdc6a59c60d9ebc629b99d357899cc772be3d1259bb015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d53a7027e20ac6cb72fb0510214007bd3f799057960a67fe2bca3b91be84612"
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