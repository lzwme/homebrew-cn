class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.4.tar.gz"
  sha256 "131685ecf753b9eb2ef8ed95a58ff0b868aef79995ea33d81ab4f20528bdcd8a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b9b7f66f5d2d5ac98f7cc19ef2c8ad91b4f102df0cac7b4187ada9ba66c3a0c3"
    sha256 arm64_sonoma:  "d9389c415e4b10815fcdedb4b3685b34239ebb5225348c54e26082f8b7ff6520"
    sha256 arm64_ventura: "900d9be2d996008252673be6d08080e3b656d27f3e54825fe5b996ace29d25fb"
    sha256 sonoma:        "00fde38c962ad7fe13f61b5598fa11db12b9a9dfbb440a904b221caf8b032c29"
    sha256 ventura:       "25036b4f467d7f44d9e1120d02b8af429f2ac83e1b9138911484b578bcdfd83e"
    sha256 arm64_linux:   "acc5ff54a9408fdac4eb513b33816eab6c0be5c287e6784347b0cec4ca85a015"
    sha256 x86_64_linux:  "5f73bdfaeaba4a95ee4c17e03d9560b6fa012940739a71422d82c856d77aebf5"
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