class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.7.tar.gz"
  sha256 "dc3a9816b6d58791ba1b75ccdba446eced0f5228777607efc29d2c4e3b7a190e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5e9bcacc4e1449836c101b019362415e30030d95d486c6448deccdc504f7b09c"
    sha256 arm64_ventura:  "5d96cc632f21e91ff7f619e25a1f2cfbf2e9f64c9a92345ef5896dde7d4a413a"
    sha256 arm64_monterey: "bcf2c2553ba673525be5a5d7171b8e9145985d3b19db65adcb025ad0b40139c9"
    sha256 sonoma:         "d0ea7ae9ef7c0961c1831170ef0f1c32756daec3418fcd54f978eae5a9a674bb"
    sha256 ventura:        "5ccfd3f9de79a354cfea3792004373a34afd79eae152f14304e74ec47819e56c"
    sha256 monterey:       "f0dfc023e5fe22a5c9834e0b1e3e305e69fc798ae1478955cf48bad25af5a1ce"
    sha256 x86_64_linux:   "af2a06efb0bbc76746fdf68a46c64444e0e32a16f3664d424a5e08fec232d479"
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