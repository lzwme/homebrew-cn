class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.5.tar.gz"
  sha256 "1ad3f67c995d186e1d3e8ab143c200e60385b25fea9827433ebcca4b81c325f3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "22e2fe6f307911ce8fb2dd25cf60a1a4fc99ac7875c6cd881aa10804b48f54c0"
    sha256 arm64_ventura:  "c7186f3d0592de070160cce967f729204afeb6ef3e9987f61e5a85613fd13114"
    sha256 arm64_monterey: "8969f68d2cf6bd0938244c87280daf0d8c7a69de1d309e7261647953779c90ae"
    sha256 sonoma:         "3aa7d8db8c2ff1b077d8201bf0666970b15ccb20077946cf666c4b45f5236006"
    sha256 ventura:        "4468215a0c5e1b15dae58b30f1483bbd2ff65fbd6937a49e9c854d43062c082f"
    sha256 monterey:       "b4b5a9c8c0004ad1558ecc10e90f63c79864a18ec79a988cc82738fccf39dcf4"
    sha256 x86_64_linux:   "7d9e85626c35bd6abbffcb16e3b0498cd18d5677f35a6605fc25953d7611ea0c"
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