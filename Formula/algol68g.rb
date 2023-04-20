class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.8.tar.gz"
  sha256 "0da918cbe652a1151895fc506a8747c753fb0b075453dcde5736ab27dc9f42bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ab021e56b84cc316893a04681a3344e4a94d05f11d78ded73d4372c536ea906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0e97c211193d21251564d5e95b028664dcca3fcf08bb752a148b0f1d2d156f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17576bc5b4dc9ea077d44e9d397c50afd0f3302e1a3d3aaa72e60b45458f6d8a"
    sha256                               ventura:        "8865fc1d9eebd54b20eaf9686ca9cd529588bba6685aaf21d3346a7ccf97290c"
    sha256                               monterey:       "7da3f5da559547aaa2f1a1702c9b340f446b379f50e4db92d7b470b4a78afe1c"
    sha256                               big_sur:        "27e26584c55495acc368dc0f01ef9a7682b4e1648edcec309247039354c17932"
    sha256                               x86_64_linux:   "d8f43cb88f905f04e91322157fc3ef7158b96bd6e950f017dbb7c3288186fe84"
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