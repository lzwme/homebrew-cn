class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.2.1.tar.gz"
  sha256 "881cd9fe3287453dabccc4966942b6ff6de293be787db0cd19dcc5f25f059c3f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05121a7cd923ab4258f8f4f602d266810a03a4c6f8db954629e63f8f87eff9b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2034596739b415b4edd1ece8febb883f15d2063e839efb23ed24a6cb24d2efed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73467095ef6b8f072f173d9e3e05ad426a54adb3e6f98a688922e1a8a825d961"
    sha256                               ventura:        "476541c06cd5d7b94c2096ad43e6ab556936c504cd78770afc01ef615912bc5b"
    sha256                               monterey:       "e0e925fd6f4e9fabbc456a2c796c4145bfe91b5443cba779a94fbe9763473996"
    sha256                               big_sur:        "ef1c3077c3284969040bcc0cca1c79f900f5083db70813089cba8501e5e0d4ec"
    sha256                               x86_64_linux:   "b1743f4020a4a5e58a6331d308601df5508aa042a802f499b5650180fb8ec934"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
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