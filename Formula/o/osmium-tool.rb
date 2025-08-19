class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://ghfast.top/https://github.com/osmcode/osmium-tool/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5438f57043c9df05137ca4bd1b1e4a5fb1c9c8c49cb4bec43a5f1ef30ed68fb5"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82ea7f2e25dd883e8c8a540d93aa6b8715cede6547d884fc618afc11d7d3ebb5"
    sha256 cellar: :any,                 arm64_sonoma:  "4955a8b62dbac9ebb4c34c4932a8be2aa3025062e9393c8b11cb43a2ec4201b5"
    sha256 cellar: :any,                 arm64_ventura: "4a6a6b415eee38d9b8366e315b00632574f8b898faba3a6c4e8e66dcc7a70171"
    sha256 cellar: :any,                 sonoma:        "b06c75e76e0dc8589fb97234173db89c75f7ce21f3a5921da27644454094ea2a"
    sha256 cellar: :any,                 ventura:       "26f49bd23c8c4951ec550c07b82d555c0c6e9814107e9b05e3a2c2dfa9e05c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5655daffbc41e0a1a3f06a662bebc703dfca29775181b4204cff60d85e3c1194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffef4f7151bf9213a2bdd6274b082187d07fc43d99882fa51e97df3d3215736d"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"

    system "cmake", "-S", ".", "-B", "build", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.osm").write <<~XML
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
    XML

    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end