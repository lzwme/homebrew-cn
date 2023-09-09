class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.15.tar.gz"
  sha256 "6958beb601c75c964b2297435d62955311249aaa37843e2d101f7b9a45d73f65"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b4eee3fc61e35e1cfe2861fdcdcc5c0aaf18d88155c609b8d8565356d014c05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8c5086cbe68033b5c34d1f77539e77d8cc18c229c27c372c9bb74ea75e42c67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d66924e6fa15b4a6f42765dac9f77b362d4f85e62efbacc2a35f27a89399a3dd"
    sha256                               ventura:        "e9ee4efb6a63635c1e345b8a28f73fe31ab81ede28003dcf3960fc9f110a4f53"
    sha256                               monterey:       "a14e741e571ab24c1f26ab2af7ebbfb98743070718575ebd4cad14e861f266c8"
    sha256                               big_sur:        "e3ca9260736a8c341c74bc0e71f779e5dac53004eb07a80615434b591d427627"
    sha256                               x86_64_linux:   "e1f0ee0f8b3ba81e998a19629258cc4d65b0c52689dbdc7f68776bfa09f26f3a"
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