class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.1.1.tar.gz"
  sha256 "89e3d7898995d1aff44c0231d65ce2b78d991db198544723526576f9a46f0578"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "f945601e6589986edf77a2169d849795773a173fc81e066f538e46992cb94cc8"
    sha256                               arm64_sonoma:  "f1a5fd61a2d30e41152612e2e5f667822b2f62cbc25566686794dacd878ae18e"
    sha256                               arm64_ventura: "efdba3c9444f561b69eb6419c9fd16b0a8ddb00d80a688ca1ddb34d89ea9a7f6"
    sha256                               sonoma:        "7641fc9ce25a319614c22fd1e48086b5a59e785e46a735546dea02cba9bd735b"
    sha256                               ventura:       "d88f75b978197bd8c46926e80ab3a18405793f4582ee61a2e79d69ba903bf38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7b06a2807cda2fedad502ac4420125850cc2a5d505e10fa152d876471f9021"
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