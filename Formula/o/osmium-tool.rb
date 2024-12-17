class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https:osmcode.orgosmium-tool"
  url "https:github.comosmcodeosmium-toolarchiverefstagsv1.16.0.tar.gz"
  sha256 "f98454d9f901be42e0b6751aef40106d734887ee35190c224b174c2f27ef1c0f"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9935acb79dc891c9293def4ebe33455538b5b9c5df5a5199a36b60e965f9e45"
    sha256 cellar: :any,                 arm64_sonoma:  "7af99b05b60837be477c18e1a4fc6d46f0a925f1da4f9c0df4c96f3283189762"
    sha256 cellar: :any,                 arm64_ventura: "0d43f806c48ca293ca43b7b79049da4bdaca569d8dbce79ca64aec2dd8f13157"
    sha256 cellar: :any,                 sonoma:        "8681a76151572d68f50c1696e62ea71e732112f2658216f016c5381213fa3248"
    sha256 cellar: :any,                 ventura:       "3489132658ffe95e5410d445b61771fc88ae97257e1ceb4f8ea99c12a74cb9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d98f2f747206244f51dd7d7b8a40978b2e1e1016b52f08ba0165d6cfae589971"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    protozero = Formula["libosmium"].opt_libexec"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.osm").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"><node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"><node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1">
          <nd ref="2">
          <tag k="name" v="line">
        <way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role="">
          <member type="way" ref="1" role="">
        <relation>
      <osm>
    XML
    output = shell_output("#{bin}osmium fileinfo test.osm")
    assert_match(Compression.+generator=handwrittenm, output)
    system bin"osmium", "tags-filter", "test.osm", "wname=line", "-f", "osm"
  end
end