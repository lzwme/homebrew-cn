class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.13.tar.gz"
  sha256 "fe3bc0ede6e2d15ae4ae80da3e93ff20a94f7695619b52c626c361381617de9b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "831f86edc6e5e0a150830a5fee4164377ae381f4413f5aafe272288bb92c82be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb0170b16b42a6e19230efcd7f9972492a0b54aad3d27372f286e2618a299f50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8de641f4a3b74e9d7d36dc7c36d40800e53e1641ba649ac60837210695a0a19"
    sha256                               ventura:        "aba39347426683c4859ab87e61013715877bd3432897dd8c8b9bf77d071ed0f6"
    sha256                               monterey:       "96bafc29dd1bc750868ecfaab83192ad2927831faed2feb74f1ec11e41d0f9cd"
    sha256                               big_sur:        "5165ff6ef0af2120cf2c5904b0e6c9024c4fe193fceba3956d50d5d0fe7a7fbb"
    sha256                               x86_64_linux:   "2f5bda330bdacf0ccfaee149af9413ca6216438eefc257c152914ba1beec6315"
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