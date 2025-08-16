class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://ghfast.top/https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.58.tar.gz"
  sha256 "dfdd7030234e02d526f671eba4bfdc0d5006e350629c2a14c49f22576b5fef69"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf680589b9aa30265313336d529b3a4217ed77419009891239e1535bbe67d2bd"
    sha256 cellar: :any,                 arm64_sonoma:  "e6ded73d154d6d226fad93ec84e4bb0c9c6700a4c6c15037764ec64392d6409f"
    sha256 cellar: :any,                 arm64_ventura: "57a5110885a6dbfda9b8f2f31ebf49d8d6c0e32fe7be1d4946ed0d809545f57d"
    sha256 cellar: :any,                 sonoma:        "290291c7b7d2819109eb7c5382e10c206338a544270ae34db2e1197e744ea5fa"
    sha256 cellar: :any,                 ventura:       "9cc0104bb396bbfc693a728ca8457ba62cbd7f47c6172c7d50c1d465657e54ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c191119edb22ecd101e7f6817e95fb7c79ebfce1ea9a01d045edd0caffdeb741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0820e540deca38ef18c25f10b4ee0ba48736167f03bd45b1d56a9220449e1c2c"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "vim" => :build # uses xxd
  end

  def install
    extra_flags = "-I#{HOMEBREW_PREFIX}/include/SDL2"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "lilt"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "decker"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    assert_match '"depth":', shell_output("#{bin}/lilt #{pkgshare}/examples/lilt/mandel.lil")
  end
end