class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.7.tar.gz"
  sha256 "1cb5094c6881c4061ea4168c0b7498075070e30709f0938a3f9ca929cba89c5e"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "2916c5d0aa7f964607b3c50e0f8927109ff0c082edd7a679edc3a058824c15a7"
    sha256                               arm64_monterey: "b2e3e6036102009a4232a73f249560dd521cd4d02268b4a967e61c23c41e9466"
    sha256                               arm64_big_sur:  "5c7cb8a536bf5d10bd71178b1a3c9c0b47a00d76eb04c23528edab79304cf913"
    sha256                               ventura:        "310d5791c50834e08ac0e9b86f45de4115f51307ffdc48f2f6c6bc0d4d243c75"
    sha256                               monterey:       "b90b32d2ce07f174966ae256a51c07890c593b3eff57d50d2e3a2298aa96b205"
    sha256                               big_sur:        "f429ffa410dd7ddfd1bf42edafabc6646aedf16f1a6a2c6acea558bf54d4fc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83540c4ed84397b56aa6c37b55f3dab2476980e9261cba361d23b8d7e9028a85"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end