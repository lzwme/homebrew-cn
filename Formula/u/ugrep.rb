class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.0.1.tar.gz"
  sha256 "59241f3ce62bbb00c3eaccfd218d18191c7acf0e91d217db28010af3590259c9"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "8da4cc7c129097c738c12836f08fca05e1799bf41d3c9d699a7898c4a27cd6bb"
    sha256                               arm64_sonoma:  "2a9162e1029483b6097bd4cf2e425de051d7e3629eb75b1c7fcf3a744ae19ba4"
    sha256                               arm64_ventura: "18f3175da7cfb548b6cfdca6624de9898ba2bc4a6a0dea43d2ed34d2c49a2716"
    sha256                               sonoma:        "899ae7809533394e7ed55a022288b9eace257e6b0a1415892405b6ffc471b401"
    sha256                               ventura:       "b6473450e510dc5afaf4b3d5d0fa4dbfa5bea489944ac99ff4e5e7acb87daa75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c9739dea029952755b2f73c6ac591369617ba7ecff87a6652b9b51e36ac9b2"
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