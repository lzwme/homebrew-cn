class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://ghproxy.com/https://github.com/phillipberndt/pqiv/archive/refs/tags/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 7
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "217d3090865e9025455c77e862502ed8f1ee31b3d7b0bf6961f75bd34cb70756"
    sha256 cellar: :any,                 arm64_ventura:  "e39d81dd7fcb76f083f48439717b161df7be05ea5a0291d94e43a40dddd3ee17"
    sha256 cellar: :any,                 arm64_monterey: "c8354961734f265d90289e333fcaaf97c25516793cdc51dabf1b82428dd26511"
    sha256 cellar: :any,                 sonoma:         "d45e087f18057e0d7508d538e1351e6ede602eb8a2825bec6c8198ff166f5453"
    sha256 cellar: :any,                 ventura:        "1d6db02f4f7052a4ee917753d76d565a3acccb8dc524049ab3b7caf4ded681ea"
    sha256 cellar: :any,                 monterey:       "f581b467a32731ff9260edef665a94f5ab00545349bd75ab429ddae97b9bfc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b4f576c256f35cdbd95c9a652592bc8da8f63727a27345c9d1a21d1effc24e0"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end