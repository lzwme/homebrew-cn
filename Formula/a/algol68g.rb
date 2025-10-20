class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.5.tar.gz"
  sha256 "cc9b104b3e3384bb4b36821cce660c71f910e1c404a347bfc7eb817c5b121cda"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9b5ffee64033715be346cf602edae1ff2dcf173dba830b85f287a19aa92841e4"
    sha256 arm64_sequoia: "8ff432584f3421e7a7da19fb462b13d9c82d5d4a6071f96351806e8aeef2e4b3"
    sha256 arm64_sonoma:  "d21cfcc6a7668085847d77ea0721b1667bdc78152c13dd3589a9abca4a6fc3cb"
    sha256 sonoma:        "c7333068a1a3a6e17a29920ace37204a03467eef2df856a2f03478665c5ca13b"
    sha256 arm64_linux:   "d51ea28dbd920c6637150c68f608204311429dc754756722a33e605d095be35b"
    sha256 x86_64_linux:  "b127428b3a48a328ef7b9f805eaeba8d791da351444e6cbab5711767ab68a296"
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