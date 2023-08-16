class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.0.tar.gz"
  sha256 "bc159c355563d1db303131a75893f0c9ffc630589ab5fc5209b2eb2bfb5990bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6877b3de3f0b81435ce17aefaca903dd4d6a493be677aae3f608683cf01c7185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853e704632abaf6340a15182ba82f05ddc3c2e8acf3b9559d4794afdf7291553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883b071d7751df06824903a15d5d8884e08f659d09e49c61620a83996a363352"
    sha256                               ventura:        "7b66d865fe499e01535c20817a516c8c53ea825e47c391927ea9e34dafbdcea3"
    sha256                               monterey:       "534f8b4083304c99afc4df18a0c6672ccf93b5a731e9aa0d85cc876453e450dd"
    sha256                               big_sur:        "7bda31f52122eaa7869b068dfb6f11405e092d66a8ca5072cb46cd4bfaf08dc7"
    sha256                               x86_64_linux:   "bee86e091af4944c8459bd38ace088eb503f463bb4548566d44d9ad7798a3fd9"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end