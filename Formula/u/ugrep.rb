class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.0.2.tar.gz"
  sha256 "9fb583a1569d070016ee8cf801b923f55b10556e64770fb369837f141d180449"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "2bc41f9b678e1ee01068bb12d0a2b945a660d97a4d7969959a0487f6db3c3170"
    sha256                               arm64_sonoma:  "4d3d478dc4980f8c5dcc704c19cd42d9ad01e28b780c71f501584717f0ca13de"
    sha256                               arm64_ventura: "3e65134bd5a454ac7d799c21e7b13f5d637576122d4467f939e711bab1f0d50e"
    sha256                               sonoma:        "768fe56380aacf8169f2eb69ba0c9ab9c85ae65e56ee683779cb71368ce0721e"
    sha256                               ventura:       "df55e58452d295aa9049c5ac448ac892a4f6b8cfc39592d2fba1000689521787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2f9effed061b2610c9aa87a150813a66526f26046e999a4af244edaf5ceaab"
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