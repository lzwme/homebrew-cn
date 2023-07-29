class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://ghproxy.com/https://github.com/propublica/simple-tiles/archive/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9c87c06fe966d1d5d23ef33a704ce840dd7eac9068d1eba236b77988ef17b27"
    sha256 cellar: :any,                 arm64_monterey: "2634f8ae7e3bd268d7b893b45fd34be835a2e767a05c37d4351d98f3a7ab04f7"
    sha256 cellar: :any,                 arm64_big_sur:  "dc30859d4007fed056da65adf29a4c6c460f24e949db41a84699e64d9373891e"
    sha256 cellar: :any,                 ventura:        "46f180fb0311163650cc87e1311c8af40f11ae7c17f1e4465852ad224dc73e88"
    sha256 cellar: :any,                 monterey:       "30776dce070adacb6eb2860b3507d1c396dd026f29ae3d53ab631bd1ba33a331"
    sha256 cellar: :any,                 big_sur:        "d39cdd73323bfd7403c6dda42eec2958fb2d4c791ad66b10f53bc09c21cc0494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176d49ea6c093e741b3fa44b90d90b82573748678a4e38338960d8d43d9ac469"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    system "./configure", "--prefix=#{prefix}"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimple-tiles",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdal"].opt_include}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-o", "test"
    system testpath/"test"
  end
end