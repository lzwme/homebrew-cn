class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.5.tar.gz"
  sha256 "ffbc0e035531477fa945138843765e3b95e656b7e4743e9f7ca034085e8bfed1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f1ac5cef718e73b1d689930bdca235009a5dac3da77d509c699845e46ca32e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12eda9ce2c067001ca232b9522b2405b32762808e9bf2e2b99a3a5c4db26674f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dc67a535981ee8d02a486585b48f815a8f96b095b6d6904494c45954b9e49b3"
    sha256                               ventura:        "fca7c60259d4cefa36df921995b6126ad7cca5a119fb38f87bec66e210982b44"
    sha256                               monterey:       "9caa64a386cae3b32ec232f93c26a88433efb7900cbad10aa052a979615d0015"
    sha256                               big_sur:        "3cc12581a64f6634e29614d071946ab5ba9016efad1fb07fbd4b35c0d509920a"
    sha256                               x86_64_linux:   "47d5efe8f8b5e393e4e47e3c882c62b487f801973532d36b8f5f2c317edb1bed"
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