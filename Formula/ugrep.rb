class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v3.12.6.tar.gz"
  sha256 "96415667f88f32bf2cd478db8f488e29ff293576e66f2d39e223a3bae1a15eb4"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "170bfb22f6317ac9fe07987974d750633e16ae020a45823d51011f49d2bcf958"
    sha256                               arm64_monterey: "d3e964503174214090c40dfe892701966467fd3998d9c7f3eaf271987811f7e7"
    sha256                               arm64_big_sur:  "168f7fb943f6ab19e6dff43067e40a922a0c17e40aea65af0f65dae69a68f441"
    sha256                               ventura:        "cecb6b8178a9e9cb98f5ce20880828cb3df30a21813963a01e0d9a3955b8c1e4"
    sha256                               monterey:       "e28c1a07996921bd7b576041e2e0abfbb7345a6f1aa44b08369f398ac272ce4a"
    sha256                               big_sur:        "d96548272b9352215775c41b4bc30f93d6e33d68a5ad393f13ceec6ee2bedcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1496346ffd80b425457c17d73e0781d4db1f9ab44085299ccf242892298c205"
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