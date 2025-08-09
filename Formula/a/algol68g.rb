class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.2.tar.gz"
  sha256 "6c247d94f2a35c8b761560c9ca7450785c6f098d98d3d75ad870ddae756bc7e4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ae69a582493dbfdd55ece1a49bd486d50157a014a842e04dd70448f0d4145007"
    sha256 arm64_sonoma:  "458895988649a0deec45faf582597c67a0e1f211e9bce749bab128323e71a98d"
    sha256 arm64_ventura: "a5834e08d42718866ceb17fc8c0fcb257c6753bbfc13323afe01e5a0138ed35d"
    sha256 sonoma:        "60ba025ef1ed696fdfe5e5156a809d94efc818eb35414aab73dcfd525fee8036"
    sha256 ventura:       "b62a4ad1ed18265568a36ce74098fa5cf81786988c0687b69ef8e02a27f6acf5"
    sha256 arm64_linux:   "ce106d88c9aaabcbe7a4c6381139d1a726645f7fad2f63790f2a754949c7da08"
    sha256 x86_64_linux:  "f4f17c1ab46c143f79eb29a9d14633f96a8ecaec6d9e35707dfa5e30b904de86"
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