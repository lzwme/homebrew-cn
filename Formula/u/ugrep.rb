class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv4.5.2.tar.gz"
  sha256 "01fabb1d65775aa90d60d37a484675d81f3d688b0a29a2ec732c7843bc2b2f32"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "43521a11f3fdb853c2d95f7ed4ce03ec243c938fa64b0570952cbfb2ac26cb76"
    sha256                               arm64_ventura:  "1aca1f362764e58fc6e8a4594bb6bc16e643fc9dd592b25b269fe052941ad1de"
    sha256                               arm64_monterey: "f561cc051b644843251120485101992f20667b10218a01dcff5cfe48e760f534"
    sha256                               sonoma:         "a25aac29eac904845eb08d426f69f7027eaee6c9bb4c4b6d826dfafd9bf76a0b"
    sha256                               ventura:        "5b936d19cbd90ef2005e200c59e17bd2a88584540e230b21584ad953cc0cfe7e"
    sha256                               monterey:       "b4b1d88261f9967edfb7861e67896afbe26767d8a3f4df68c7e9bd6895254e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc69fc806d93ceea2ed9e586c4658820ef0c4f222338ef19067406ef539cbfa"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

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