class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.2.0.tar.gz"
  sha256 "c93fc62f30aedd42b3d0583df072bd506ecd1410df41353e92f84ce19b0b9364"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "5c1afe6584f3360ccd5728b47162b36ee54a87b2fb8c0e14f73914f4f0eba294"
    sha256                               arm64_sonoma:  "53dff496ce3d0de8419b7b62cd9dbf99813ed2d81bc1800ed9b5f4de4b1e13b2"
    sha256                               arm64_ventura: "2f9175d29536db617e7256b9cff4fec92611798e4fceea80084bdd88bbb7550b"
    sha256                               sonoma:        "fc19c515d79f366c24204d880a2c37f36348058b0ee3fa3aeda7cb85e50c555a"
    sha256                               ventura:       "10ea70b5ee1963ec8d3909cf6fbc49f5e7ec04e2e51798edeeb9da1f73054d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c25f2b87d395afdb48026bbfa0953958b40a443f8bd1c8ced851e1e6a3bb6c6"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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