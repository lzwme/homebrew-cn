class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.1.tar.gz"
  sha256 "a0e017c8667d9eb2f39db0b1c2559821c35a6280d04a4c292ab2e61f9663b017"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "797c4464ed5865c84cff645a3d8b4a911ba5354e7b33241a1f74c6dd6ce69cb3"
    sha256 arm64_sonoma:  "10925078ae44c95b8eab5ddc2f40f4f091cb7f9468985f1490005e4a1a0b8d13"
    sha256 arm64_ventura: "bdc56971f55dfe68aa521b20f869fa79b879f11cd710d2ab835d6c7013af0728"
    sha256 sonoma:        "24fb31764809623644cb42873cd764adbe45da9871fd35f9a3e2549390386133"
    sha256 ventura:       "6e6a5c672f25d278b9311e8cb6d1ae600d5f1ec43d779ae8e9d88262f1dc68f5"
    sha256 arm64_linux:   "1f4646b738b434353fb30d9836ea6af2da1aba30e426757f922ef8c60f4b332b"
    sha256 x86_64_linux:  "4a14eaaf14c5243f6d17356ed81e9d5e0faf9bb0b5cc10cda5bf8eebeef466e4"
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