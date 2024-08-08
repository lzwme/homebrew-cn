class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv6.4.0.tar.gz"
  sha256 "4d28168a8b6c2fa7f39ec524f25625c10f3a5a1a9b718f71aee8dd6bc51e6eb5"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "537bdd6ae038d1f942951eac4b407ab6b3bbd20774afec920774db71271d35e2"
    sha256                               arm64_ventura:  "0ed1febd69e01c37cfa9410186e2ec37ae74d4b59bd4b73925fb04bb28693c08"
    sha256                               arm64_monterey: "4e3b232bc96a77a0f60f8b9146b422b7f0f76fe0ed172c3a12a0e35a1dc78e9a"
    sha256                               sonoma:         "3fecd4ada1b7be698b0ad0e431469970f4e0049874d3226f9310ec4b77b1158e"
    sha256                               ventura:        "60279337143a9467ca5e8389c8658e8441858ba92fc653bf7d0cbafa0a5752f5"
    sha256                               monterey:       "16cdd2dc1cb46d9b3ad6e49df7a9f80952674af141f13fb64b239b7939546ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8403734cb9d50e646d13e67fbdbebbfb1b2e590e57882f99e1769f4ed414d09c"
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