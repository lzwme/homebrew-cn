class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.0.3.tar.gz"
  sha256 "9242da0f4106889a85751e72fd9383b71f9fbcee21903c5736f2e0921d4d49e7"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "fc1cf4b4924e5070facb876d59e277cf6af9aac904c3b0838d7c22eba0274c38"
    sha256                               arm64_sonoma:  "3dd7dfafbf7a8ef940e80b3bdd6b57701a4b063f1c7c0d1974fce40a34f47cab"
    sha256                               arm64_ventura: "6b56813a419f83bdacd195397e5a37ba2ddec0b44b056331156e82c91bf213fa"
    sha256                               sonoma:        "fc823686c65cf23ce1a14958b14930bab4e51842418d6112dc8439562709a1a6"
    sha256                               ventura:       "2ac9c2b4dee804387cb467e521c544c62b846e26577888309f357bc2a07095ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f82ea78e4020e0b7d288977697f92f812fbf8f9677730787859cafdfbcdabbd"
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