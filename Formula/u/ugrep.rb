class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv5.1.2.tar.gz"
  sha256 "24bac5053e994ce55ad1f587cf9333bedfe6e073412b835111969c8f4878131a"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "aa61f71b70ec2c56b00f9ad57fa38398ea0a98856573ebd8c574f3f9ad3ced29"
    sha256                               arm64_ventura:  "888b33cce11bdd37aae105055eeb6e000b116af45881ac8c5c683507ba124784"
    sha256                               arm64_monterey: "b0feac0af6b4c88ea668928f4592018fc701b605df420d1df570c7fa2aaad6a9"
    sha256                               sonoma:         "b59afd683532a75d2bb1c94b2c379e9967175a349ea3f4d9fc5291e9553a1ead"
    sha256                               ventura:        "26097ae39aa76ccd3443f7d42763fdc47aaf95043c213b50690b5eb805a75d3e"
    sha256                               monterey:       "f0511b7648c66621a734979e966a4ef2d8154a31fbb09717df4e1247390ea0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92a9b9d8d134e67fbca82e513a0ed8636386c7bfc4276a4ef4c107319bbeef92"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  def install
    system ".configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}ugrep 'World' '#{testpath}'").strip
  end
end