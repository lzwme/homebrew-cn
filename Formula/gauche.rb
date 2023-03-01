class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://ghproxy.com/https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_ventura:  "fd3ec657cad0360add0a8f9f73ff6c661d7d15ab3d15f40050be07784f5c0c2a"
    sha256 arm64_monterey: "aa40d93b12a3b3e14c4dd5d2eacc37453eb2eb31d717cf9ee594b7e073a445c3"
    sha256 arm64_big_sur:  "7ddcc857a6b27da9c161eaa0c21a98af4548e2a524225780a3e47ddb337c2d0d"
    sha256 ventura:        "2ef7ca32002f86bfaa76bb1ef462f241c01644f794ae0c3b894fbc497224df0e"
    sha256 monterey:       "7dd595ed94224a5ccbada1a2553e7948c20bbd25e2b73e289f9caf714b4a5dd5"
    sha256 big_sur:        "194be9d2e2c78b03e18514600f5d59d704d0f2ed24b990ff9d4f78d06fc282f3"
    sha256 x86_64_linux:   "62d348c1ec07253313eceeb34f48c35c30120b0a8416f5bf39e7ed44a51372ae"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end