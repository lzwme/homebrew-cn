class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.6.tar.gz"
  sha256 "f1e9e8d5aa2f970b1be93fbf6977aaaefc25782bfb1e3daed796df60311c5eb5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8dd220221489bf1d2a02293f701adb72ad4a40b9a7259be523e1a9d2958a18ba"
    sha256 arm64_ventura:  "fb7108350dfdc253d460c99ac29b28395d85c74e3cfd5bfc69eca3d4b5fd536f"
    sha256 arm64_monterey: "c7b2257391a63dedb63e531552f3656e6b3cf86153978d83c1436648fb1983d0"
    sha256 sonoma:         "7617a978956b939714347b36da2e47c439840cdc0fbaba4550440e568cc771cf"
    sha256 ventura:        "352bfce269e161a86b2018daeefc7de50980bacaff100b315398474dc9664492"
    sha256 monterey:       "1616bd587e56fd98105c8ec2191229e8f51f02fd199f33596386707a1c42ff3b"
    sha256 x86_64_linux:   "86a3932294239c88e8e303ebf23ea0b5d71bac7d6405c29228039557a172eced"
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