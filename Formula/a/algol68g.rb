class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.12.tar.gz"
  sha256 "4c8412b1928efdff8e9c35f17b37809c77db3326d76122907acbba797beb18a8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "adf7a071a3db8a93aa317baa658b520454fcccf7254f35c24b1b3c977f5d4183"
    sha256 arm64_sequoia: "d18bf559d10635b028d6d515f61a072b670fbdc02aa0f17e3ac253ea923b4b8b"
    sha256 arm64_sonoma:  "09a84d511b1558611b7c01684edd5caee2c41da68f3817c569948d91a5900c40"
    sha256 sonoma:        "f16f0f4c542c890aaffde5a81faf8b285e483a71486e990c400ad3f86ae6022e"
    sha256 arm64_linux:   "3bceee6f46e6bc9d5fa2e0051da79bea95ee4c8598a24eb0d93bc202f9a9be82"
    sha256 x86_64_linux:  "518e0e92889629b8f5d858f1dff4b90f2be5d8ca7efc3cb2fdc3d562ad2f8465"
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