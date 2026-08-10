class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.13.2.tar.gz"
  sha256 "cd19c88ec02bfd4f5fc0c84ce0b6d33af5c819bc637de44ab48c9ff990701178"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "32b914e4e25014f2bbe6f440893e7b43f52f1aafa5186e2e1b9b5ef3c7ca1a9c"
    sha256 arm64_sequoia: "3715683c968fb4c4a12613623f532f86cbdc8ef013584c2a2308f3fc52dcbca8"
    sha256 arm64_sonoma:  "96c04884ccf0d6ba330bb6a6b200d9f544047834aacbaade3e52fce1ded6cf7e"
    sha256 sonoma:        "bbe90050b3c96ecd200a21323d499ae9228a7ab85dc5cda94cd2626102ef1607"
    sha256 arm64_linux:   "53c5eb8da81f330fb08493445d03dc4c37168b3b85e3ec85e5447cb6a421494e"
    sha256 x86_64_linux:  "d46033b4eaabd0a91441a8f02d38e4fc67940dc4998325a071f271abe66b5b3e"
  end

  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end