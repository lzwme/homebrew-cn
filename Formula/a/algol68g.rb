class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.0.tar.gz"
  sha256 "54d6fd15cd0678576efa22e8c1940ad3b080f46cd2186f6bfbcd2ffda559f0c2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "933ff39644921e186a6ba34853af3fcc351e72d3bf3c3217c6f65ed31cd8dabf"
    sha256 arm64_sequoia: "6d1a2d88840fde7aa2dab28f6745de53e8ca530bd81e50fcbf971e393879b411"
    sha256 arm64_sonoma:  "b4fe42e356225db314843fe27a9f4a31c3ce5d11dee169e139c4841ba8e37b85"
    sha256 sonoma:        "e1e079ac2e745cb02f36240b5ae475dd02f8afc06e70e15658f5d0adda5d1e0c"
    sha256 arm64_linux:   "21df8e70ae1e834a7133b48cbbab52002cb2e30e399fe046126a3629a766b488"
    sha256 x86_64_linux:  "868fed1f1c05dcd41e4e4b99b672397438134b666668d37fc8efe47d03fcf6d9"
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