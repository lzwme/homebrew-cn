class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv6.2.0.tar.gz"
  sha256 "e7b54e8e7d2d9058167269673fd783651071ba1ace547cf6c926b833607d2e1b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "cb7c7ce21e80b68e128d3f07d144f01b651ee7a949627981d7fe43be3773aa16"
    sha256                               arm64_ventura:  "a4104beb439d5e5c8e6b95e4d20d6ed6670d374a944c8c58073641532ffe47dd"
    sha256                               arm64_monterey: "9e5b61084cf0978bb12911376ceafee0712bc70b0c802e0b7dc696ca56c262f7"
    sha256                               sonoma:         "62473a09fd7bf9fc5e8ff6e665f8dddac2ead3c89d64cfc3579ae59a6c583648"
    sha256                               ventura:        "e9cbcff8d075e512b051505e8fa9fe7757971fdae9c128629ba9876ee5c1fab8"
    sha256                               monterey:       "ed3fbf11229606e82af3deffa30412a590a18d90fd29526ed2ae251c46b537b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47a974734d0caf5cc0ca867c6a5b22a97d79d0e9bbdfedeb6212c05cf31089e"
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