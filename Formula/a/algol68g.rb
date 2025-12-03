class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.8.tar.gz"
  sha256 "46e407c7eae7cb7dcd65cec7a562a94921752126e3cb8cfcbe701958eae4e850"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "20f30bdc6b4365e282e41fe364a2e6a2d4c60d805b63d6fa51d70a52b933e846"
    sha256 arm64_sequoia: "3058751105fb3590c80f5bc8a63fcf9899628cd171bb5c5c39742cd6f2fecafb"
    sha256 arm64_sonoma:  "f4e6e074e856c51dca98008138257e2457553da469757a6e556c001870c6f871"
    sha256 sonoma:        "8f896ff4fbbfc7a5bed15de9d5f29b23dffee7a796135216ac4e9800a0cd5019"
    sha256 arm64_linux:   "75b4714f0e379e7e6c6d0958e92f552439102a6907d43a2d9757df9bb68026b7"
    sha256 x86_64_linux:  "79fa6d707c6328f099f395241bca63dd5e9d8b6b0dcd496fe7ab77f4a1278d89"
  end

  uses_from_macos "ncurses"

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