class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.11.tar.gz"
  sha256 "0f804ec4a836c3255296655e7cd5b1da2e6a3340195257c2df3b13d0369c706d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac9fae212a90d3f4e13c8470ed1aed763736f59097b3a7289eea6cc9cebd5bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906dc5b63afcdf93ff40cd7c16bcc374c81806e2bd6ba95e5b3e2f8c24f664bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "038da96df79a3ebaaf2abc5a73445ec747e178e1479a2cc162d93f6a76f9a6f1"
    sha256                               ventura:        "eb9468a31d95fb4e696a37129d06a7958f95c821041bf232c969731e5f9a8fcc"
    sha256                               monterey:       "3073f4e5796e165171a4447cc3bf8f14527f9f92c47994eece2d0a2b954ec706"
    sha256                               big_sur:        "34601ca0bd752eba2944ef7b509d71ce628cf95fdac2c82f2940fe8cb1084a0f"
    sha256                               x86_64_linux:   "bbe15b24746c219f30913b5ff41a46f4ff433da0719786c39f97c294a0f3eb1e"
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