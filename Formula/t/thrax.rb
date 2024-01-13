class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.8.tar.gz"
  sha256 "e21c449798854f7270bb5ac723f6a8d292e149fc6bbe24fd9f345c85aabc7cd4"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec7dd463df2729df4f5cfd548f3ce0289ccec3e730f2f976f5bafbb730a7bd9d"
    sha256 cellar: :any,                 arm64_ventura:  "08dbd282a789ff727b9643c363934fb733dc5ede7517b12bb2ed43c18f7e095a"
    sha256 cellar: :any,                 arm64_monterey: "7321678718722cdaf250061cebd73206d42d44a0f146fc64a14384d8a72a4d2f"
    sha256 cellar: :any,                 sonoma:         "404c34a7acf68f3a49e09c0215f2db38571f4b6365923b50b8320ea0e034565f"
    sha256 cellar: :any,                 ventura:        "6d63772162ee9e16adfa82404d940d3ea2ab49876b94edbf5977e93eb9ce30e4"
    sha256 cellar: :any,                 monterey:       "d98400a66fb2af93af2dfd7daeabd6f8db3dd12dcb9fc9367cd648fe83af0cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd4783fc9a85f50dbee1a41789aa1c5c1c0d44a0d5b75fffda134f82b28563d"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openfst"
  uses_from_macos "python", since: :catalina

  fails_with gcc: "5"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"thraxmakedep"
  end

  test do
    # see http://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system "#{bin}/thraxmakedep", "example.grm"
      system "make"
      system "#{bin}/thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end