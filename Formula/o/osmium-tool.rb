class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://ghproxy.com/https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "55329c1becac125aeb151223fd76b76ccb81aea0d6ce15fb3c2232e3ca4943e0"
    sha256 cellar: :any,                 arm64_ventura:  "db12bbd293ca97a9aa6e368d0528eea332305d6907cdac8e3a433ce6bc09a243"
    sha256 cellar: :any,                 arm64_monterey: "e2c7fc365262f6ebb99429c03d756a59129e9b5d4929c91c68e614c7edd9934c"
    sha256 cellar: :any,                 sonoma:         "906525c1fe6001685e8aff71b7483eb813be1c4997f34a25685764d23617aede"
    sha256 cellar: :any,                 ventura:        "69b1356c9997b12d054443564e84108f71c60ba2ebb30ba845dd94c0c599a257"
    sha256 cellar: :any,                 monterey:       "e256f4edcdf493b546f56f009182620de8359bcf7ad1824000f37be677eafa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fe8f6f3c8d8237b37bfd4b6b418b1a64352aa88a2fa8a701c338ad64c82e486"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "expat"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS
    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end