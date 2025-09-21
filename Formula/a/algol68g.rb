class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.6.tar.gz"
  sha256 "2fd7a94070f76626e8e00aff9e792ce7fab91b038d52637abe93fda340aa33ca"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5d5d248d45ee1df6e63b498e57c4622bb7116879926949e9d968f8a0715ed017"
    sha256 arm64_sequoia: "87b92ca603f93af3efdf95c3b8ad6228e15fc4382430d44c8b73a96db7720364"
    sha256 arm64_sonoma:  "6df293fab85c86239fed1eafdbd9a9151e8ac6339b3a729c8a45a75673f099df"
    sha256 sonoma:        "335077b9b72ca9e30b036e9c17752e5bd9287789e3a13379e6e2fb53b2255415"
    sha256 arm64_linux:   "501e8d04cdbd572a4bf958eb1b58773b506a287ae7be6e763f08eb913c9b5cc7"
    sha256 x86_64_linux:  "c3b773544c289b3918fd43745ef2f45d381fc70113d689e6ce542a4d17621f26"
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