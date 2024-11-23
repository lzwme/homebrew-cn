class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.1.0.tar.gz"
  sha256 "e821b5747d3bca17a71c49a704f5b5a383e51657ccb13470b456e4da5016ddab"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "99301af699b0bc449bfbe89ff75ac5dcce2086431a317e313ffea4cdcc124cd5"
    sha256                               arm64_sonoma:  "9deb34f80597c25684501f81f04ddf497a7992e901e3fdaf202c464cb48ad46f"
    sha256                               arm64_ventura: "bd7de2e6d010126d91e451fcf3517868868cf6805b8d4ad695099055c76b1fa8"
    sha256                               sonoma:        "86e043833c7218145e493576f4019e28c207edbb8b2fef4cf5c84b6f1e982e03"
    sha256                               ventura:       "800d5cffacf743eaa43ff5025c65894a58afba0a94a8b4aca48302dcdc2d5188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0cfc789f10a22c72a4d9ee37cd79f63f0dafffabc5ba47878f9cbba8421d815"
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