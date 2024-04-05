class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv5.1.3.tar.gz"
  sha256 "a349abb1a619e33dddbf105528bc5ba5f8d97b4f7b2c69b85d432853df3a9aee"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "3a00e99f21fb2400508553561c311f7137889fba769af5f57066c2db1b21011a"
    sha256                               arm64_ventura:  "afc35972f157045d8c1c4f4ecd61cc2c86c86dbc6301f5b67ab960cac695fa5d"
    sha256                               arm64_monterey: "0adade0b3064b2b592ebf8f8df0f74100bfd1e04692f8b11a91c019ac8d1c598"
    sha256                               sonoma:         "49f54f3ff2dced6d96843e8579fe31d59d334ea19f3b447bc6db6def14307d42"
    sha256                               ventura:        "e5234fbf4ed71f282b9e2db93df049d854c8004164f492a4640f53a3d55297c7"
    sha256                               monterey:       "0bcdac17d9d9163024fedf1317ce52b09b84a855d11b8352dfff58026010e2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a68185f0d7b87e1b8072b1715e3f0be9ef9676a4d2113dd15f32c3b8a0ce9f"
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