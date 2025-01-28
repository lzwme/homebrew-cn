class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.2.1.tar.gz"
  sha256 "10130417e265582fc35a5356305b308027fd8ed186b8cbb1399c1b8e530ce899"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "1249d71369a2a2a125c1b43bc313a0c4f7b3fcdbee46e63454904486a84b52d9"
    sha256                               arm64_sonoma:  "2317993c2b66cf7b2a0eb4420edb55e80e9021c19194a24cc032b16191368ad6"
    sha256                               arm64_ventura: "da62556267806924403f68e9e1cd7c3b8750320f76fbe7b03c5b95e44fcd8c5c"
    sha256                               sonoma:        "31b05c2bcc654952295c7377fdd84dbb2e65ef9fa3a6670975d944098b2c0b49"
    sha256                               ventura:       "188de7df7d172167f8de9a6fd3b241c1f033ef7a83e97d36b021ec851ed6b6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73f3f040fad2b781368e1516657888bc2912b1cf5c52b719d2f3b1fcb44c960"
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