class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.11.1.tar.gz"
  sha256 "0a36d7bb62c49262b433eb301d8de6b90233a23446a71484738cd35650cc5c91"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "1d999b433fff846912281885cab3e1796ed54a27dcdd1cc691bfa9faaaf16a87"
    sha256                               arm64_monterey: "e2f01ad6bc9b15f6a76d95691644c1535f1f3e8f8bee667951e5c9d788baadde"
    sha256                               arm64_big_sur:  "543dcb4b528132479550bf97a260e972e9df72cfd7e59ce7f8d897c8b9e0f3e4"
    sha256                               ventura:        "985ea8f1bcc8e9693f903776e902b077cba91e04d79511b205b3be16744f947a"
    sha256                               monterey:       "fc320143098915a7cc7dab88b5dc9c2007c3a1e89757dc17d9842992de23213d"
    sha256                               big_sur:        "74c21257da66ec0a547eae21244fd99605c3766ca3b09fdb6d9a7f87915a19aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94182602e9acd3b23e2609d44198fdeb8d4504f2bd1c577e70585e256dc8d227"
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