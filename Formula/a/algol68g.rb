class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.6.1.tar.gz"
  sha256 "286ca306e28ff08669c04f48375beea37afdd57beb5b6fc98d6bc73cba1e86e2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2a1d60a35aefef2c020f4afe331d7990e4f641b4040f6834593cd4fcdb972488"
    sha256 arm64_sonoma:  "4e07d7f06ea9d74f8200d5105eb61807cc17742929543c837551568ed174a3c8"
    sha256 arm64_ventura: "1d3d7fe359876aff548220bcd332a32058571655b75e6ff1a290e0cfd8a77308"
    sha256 sonoma:        "331b7540e25f400cb276e75c2585fa2ee4b2f48065e5ac781dd9b6ef5ecff7d7"
    sha256 ventura:       "2f40080b1f02c8c8b95253e2e38edd8600e8b7db139b60ac6019e1f58b838275"
    sha256 arm64_linux:   "27bafed7110a4c68f961da136720a310f5db9dea8d0b70e716baf8fc0e00a6cf"
    sha256 x86_64_linux:  "236ce977c7dcbacd3afbde3b157b5b9b7c1e2122a4df4fae488a30a9f292b824"
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