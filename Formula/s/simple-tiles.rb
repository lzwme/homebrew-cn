class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://ghproxy.com/https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 2
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "23c7f4f531ac1bdcae1c24421c50d25a5c42626ae09913945ffc7909330dd30d"
    sha256 cellar: :any,                 arm64_ventura:  "c22fe268a1347a3a22cecf8f580091dadd55a2a77abe48320147c079fc265770"
    sha256 cellar: :any,                 arm64_monterey: "1e51c8462fff4047daee9620f47c0828349f587fb54880ff2622f872dc856ff5"
    sha256 cellar: :any,                 sonoma:         "11345354cabbb4630172bd2b0b0ccbef88c53d756b5ed7ef994187ffaaecea27"
    sha256 cellar: :any,                 ventura:        "7a5d8229fea8fcda8efa1610d3639556f5ea4f7e897d5f3a719f728aebbbf5ba"
    sha256 cellar: :any,                 monterey:       "6ce9050d08df7573d922d05ce34fa2705e62a43ecc0d9ebf4178c1e3c4a1a73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439d4843643e955b62f8d354f11114ac47dd4bcaf23379d60a085a316585b98c"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    system "./waf", "configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    EOS
    cflags = shell_output("pkg-config --cflags simple-tiles").chomp.split
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lsimple-tiles", "-o", "test"
    system "./test"
  end
end