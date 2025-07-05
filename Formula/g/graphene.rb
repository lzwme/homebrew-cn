class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://ghfast.top/https://github.com/ebassi/graphene/archive/refs/tags/1.10.8.tar.gz"
  sha256 "922dc109d2dc5dc56617a29bd716c79dd84db31721a8493a13a5f79109a4a4ed"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "11188e7d35c1a2c58483be14dc3ab2699d1829b8a1f4819abb00cdf566e6ce2f"
    sha256 cellar: :any, arm64_sonoma:   "06b8b2bb6dced02c4ce32a827cc279b301fde81352f64880eef15153d88f071a"
    sha256 cellar: :any, arm64_ventura:  "49970a5217fa4aaa048e4181172a9170b171531d58a31cfb4ced72a68eda386c"
    sha256 cellar: :any, arm64_monterey: "93468985e1d6a4b6ef69387b400d23ad39da4a154140a759dd3154bcfd19b9ed"
    sha256 cellar: :any, arm64_big_sur:  "639518b4843e05532985844875c3a9a41c93eb8fee9019c2b8bb589b692a4846"
    sha256 cellar: :any, sonoma:         "021ca247560b884ece3425e9983b6dea68cc6b87b54ab3cdb2e79e3395597392"
    sha256 cellar: :any, ventura:        "23b03fa04a05c85a9b8dfcebbbf62461593fd419c8a619de1a2b4c0185f03155"
    sha256 cellar: :any, monterey:       "65b24ac035b8b5550dc314648c4cc3b3e2416692efcc44186450e1e76e27e396"
    sha256 cellar: :any, big_sur:        "3452844382013a409b81446e2699d996c8520a33aabdf074ff812086132049db"
    sha256 cellar: :any, catalina:       "56447899077d278b0fe60d56832082400840e10a6c126575eafa477eb7e168f1"
    sha256               arm64_linux:    "52e0d23dec6fe643e39b1c080895943d6b253eeb84727928ce249cdda221747e"
    sha256               x86_64_linux:   "978a8d282c1d1715f11bc6e701441b843a99c8520ac8108016b224932c6c03a5"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs glib-2.0 graphene-1.0").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
  end
end