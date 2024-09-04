class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http:nuclear.mutantstargoat.comswlibdrawtext"
  url "https:github.comjtsiomblibdrawtextarchiverefstagsv0.6.tar.gz"
  sha256 "714d94473622d756bfe7d70ad6340db3de7cc48f4f356a060e3cb48900c6da01"
  license "LGPL-3.0-or-later"
  head "https:github.comjtsiomblibdrawtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8a58fb6c5c3b800f97788698dde639a9fd99cf3beb4bd8bb56f781ca816ab5cd"
    sha256 cellar: :any, arm64_ventura:  "4b01f03d8831ce1af64b7ee299948ebcbc719f07482925519a6ee53ce283ff9e"
    sha256 cellar: :any, arm64_monterey: "ab6261d82ad121caeeb5945709def507dcef52d04afd1162f1473e973bc97a90"
    sha256 cellar: :any, arm64_big_sur:  "c61a83f7c2be18d086863edd67880e588dd16fee1154367aa25eb4c0537f14f5"
    sha256 cellar: :any, sonoma:         "4262d5949883ebe79316117398c332490f435c4da74a8ccaf195a6d0479ce4f8"
    sha256 cellar: :any, ventura:        "74941e09f6cb06ab0fa44b92cd40e37e340d51f8781c61ed8f7d086093d470ce"
    sha256 cellar: :any, monterey:       "6588852f6f1c6fb9585c4c0cb16d9fe2d503fd68c94d08f982a7de5d0af87adf"
    sha256 cellar: :any, big_sur:        "2f01264e3b9729a123e24c71078c5b7b5c2189c2a2ed2a8481763080ed213ce1"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system ".configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"

    # Avoid errors with Xcode 15
    inreplace "Makefile", "CFLAGS =", "CFLAGS = -Wno-implicit-function-declaration"

    system "make", "install"
    system "make", "-C", "toolsfont2glyphmap"
    system "make", "-C", "toolsfont2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    ext = "ttf"
    font_name = "DejaVuSans"
    font_path = "usrsharefontstruetypedejavu"
    if OS.mac?
      ext = "otf" if MacOS.version >= :high_sierra
      font_name = "LastResort"
      font_path = "SystemLibraryFonts"
    end

    cp "#{font_path}#{font_name}.#{ext}", testpath
    system bin"font2glyphmap", "#{font_name}.#{ext}"
    assert_match(P5\n512 (256|512)\n# size: 12, shell_output("head -3 #{font_name}_s12.glyphmap"))
  end
end