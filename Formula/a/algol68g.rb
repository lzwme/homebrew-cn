class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.8.5.tar.gz"
  sha256 "cce7ea293d5e4c1ecc15bbe299aedb6ee9100de66546f7142fd520d10147b36f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "17b2cd1a60783c72c9aa124751edfad59ada78f75bd4d7eda3ff37fdd884b42c"
    sha256 arm64_sonoma:  "659a4035827b13d01ac9e3d145f38f8f8812a68d306921d9944ef49a8c2bbe56"
    sha256 arm64_ventura: "d5295a041491eb2001f4d347767443686a59f077129bd33ca6e933fe41f27292"
    sha256 sonoma:        "7a6a8765d75651ce6df252b0ffc733951c7bb9962bc7b5cc62a6c75e657f8128"
    sha256 ventura:       "d8d791c40b0acf78f55ef913db0fed00de26940e40a1dcef3f2c96d6be838677"
    sha256 arm64_linux:   "7d0194ab9927055be9ccce1dbb73db1c6b9bf1b20c8be2dfd5b8dc9896612fe2"
    sha256 x86_64_linux:  "0123da092cecf96cc845c2297ab83412873bd1064b67c5896b2a02069f4133c2"
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