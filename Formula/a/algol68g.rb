class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.14.tar.gz"
  sha256 "759fdebb124e15a2e1db5f693bb6fe45d57b826c58f1c72538070a98eac67cc6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f8f1d88e3694eeeedf4eed1463af83c7e96251d5b447462a98b5483e5e64f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7023023d4dd9f7b48dbaecde715e22f857e37a4220084dcf093abc7651d795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "106b3f8413a26f188c883b78f619d8fa68d7c03a997f98f293524eb2555c09cf"
    sha256                               ventura:        "8c78aee1997af3ba8371736c1eabc727e26d768b41bf823bafd6217167a162f3"
    sha256                               monterey:       "b2835c84346f31a3fc215ef1e322a6590044c9688841364ad0910d644010f727"
    sha256                               big_sur:        "7d95cbf32ffe8d1a5e266ec17a45e875c80aac6f947ef118d852cb4bc93513f4"
    sha256                               x86_64_linux:   "e8d21105f0d71712f7998b45960e68552ec8154a5ceebe915135ebeaa02034f3"
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