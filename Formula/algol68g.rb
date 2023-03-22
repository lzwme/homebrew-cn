class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.4.tar.gz"
  sha256 "9efb8cb3c244f7c8535b6fd8976b0620971892f8f53e9bc3c4691a6ab512e9d0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34dd6bd8f4035b5d45f658bfc2e95683009b1401fcf17e1e8f335d701fd4c10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feec2439ae5cd4c1c4c5f796a0c5c6a57a70032577d389edd586b3cac5ada155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cbd27fc2fc6cde283c114bea7b3be30339c49acee1d5538f9b53a224c0b8d81"
    sha256                               ventura:        "71257754363fb4a4524a3f327c4f7d332b8ab5dbe2e9548e1f9eb036158dc773"
    sha256                               monterey:       "78599aec6cbd869abff4a39380052a24a4d7ba6ba180a4cd92d8a8728c639af6"
    sha256                               big_sur:        "33163d1a00e7f4f725236f6e5492308ec48041d66bf130d22ee6b144cd52bc3c"
    sha256                               x86_64_linux:   "a003af5103193979c5e69a81a111d53f724a385312ccd879bff84ad18470d5d1"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
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