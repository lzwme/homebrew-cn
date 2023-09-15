class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.21.tar.gz"
  sha256 "df2ef29e8737da0503fffceeac4465f85b24de627a766be5f6bd1f51c9d3310d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c6f04d31fec1824c943128a7ae01484c6096d40215ad13ccf812fa033e84de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f618c8fb914d533a1e4da443a939c446dade91a97b082b2499671fb7a4090e1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8881a0780ee8f73c8143dca79521737da8be5c572a274f9256b9d31833cf4748"
    sha256                               ventura:        "74c67db3823ac52dd108ee4b4f1074600e08a1bb558b9e959467ae794dc52c99"
    sha256                               monterey:       "c78b4409d0883b929b55bb8593bdb5173e2358294704e28da796040a197c1ceb"
    sha256                               big_sur:        "d804f9c1dff93790359a7ea32f899414cb624ee8ae4888ed2dfcc35b13cf37a1"
    sha256                               x86_64_linux:   "698a23c0af154efc8fb595cc3e4101f1c2f65e3cb0807caa60aa68da41702f88"
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