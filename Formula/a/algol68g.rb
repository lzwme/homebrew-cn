class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.8.4.tar.gz"
  sha256 "b84f15e61b274448743129842d5edb7362625b01854f51bf1f7e8d5ff175a0d4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "aea8c9c41b4efb3b95ca342ab727be154edb6a86dcf2aaaa56de6fb4c9427e1e"
    sha256 arm64_sonoma:  "d2ac00d8d734dc0d4d4ee8fe9e068d1e21f2a59d745c896e4d26a8f78642c97e"
    sha256 arm64_ventura: "b919600ea573824669c2457e63b08f4cada9baf41f45d0435be0d33fd154e00f"
    sha256 sonoma:        "b9fae36584ae67371133be341e844bbcb1b5c79176a7c3b1d95acaec61f031e2"
    sha256 ventura:       "12a591304a03aae18265bfe18ca08fc4bb1ad64ca3c7e1c5fd94f561ad55441c"
    sha256 arm64_linux:   "3b6753ac09a271d282be591d74cf838650b5f784fe17b099b6f3dddac728c807"
    sha256 x86_64_linux:  "e0c7ab8f1f08007000e2304029f3e8cd625ac7f2bdca2278d686215fa8ed18e0"
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