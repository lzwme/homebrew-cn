class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.4.tar.gz"
  sha256 "a36d20492026a36b8436c91f65189c7ea98b4b599c4704f170159c1d9676dc3b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "9a4024010720b2de934ca16a429a30dd44581426cb1c7cb2715b37782f94d5df"
    sha256                               arm64_monterey: "5ff5ef0d319bd0d7761c98231af50bbe59f3a1b1e6fd4d89917aaca014fe43f3"
    sha256                               arm64_big_sur:  "f0c78ca90c5a99f9451790fa66dd85d9cffe3d37e674149b93216e2f8dedeedd"
    sha256                               ventura:        "8271189f658a9301f0997efa84245a2e5417d76a3735f9ff3518f6c47a64eebb"
    sha256                               monterey:       "47b705d9e2576903025ba8a9cbfb9ec94f562f1405f1da9baaf13ccf0112b5a4"
    sha256                               big_sur:        "d1c63b6bfda15ee0d12ed2a48dde6c45900d7303e9cfae1073d4985a41ec3dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd1a54eba6f42721bcb5aad68645c3e8104416836d86920edaa299b1c63d6d0"
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