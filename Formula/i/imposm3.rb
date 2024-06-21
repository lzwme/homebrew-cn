class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQLPostGIS databases"
  homepage "https:imposm.org"
  url "https:github.comomniscaleimposm3archiverefstagsv0.13.2.tar.gz"
  sha256 "a4edb7626d929919224c3778af5a2f2d11539a5d5c30fec00bacacbc39dfb7a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce2806e30f44d312e04d59ce5d6f413e1606465fd4341fbb581c3f9f8113f22e"
    sha256 cellar: :any,                 arm64_ventura:  "b485d6d14576a96b8dbf358eec1760c461c3215ee16d8cbeb473dfec4f83ac63"
    sha256 cellar: :any,                 arm64_monterey: "bd15d0e48252112d24e07fa9a741ffd3461c9b8e0b3f2ccac3013eda3eb8386b"
    sha256 cellar: :any,                 sonoma:         "a56faaf41dc1fd37b8ee4c7e108cb6660ac7dc62ec7479ec99f1a9d2fa30f1ae"
    sha256 cellar: :any,                 ventura:        "beef1c9f5a5540ebb8d766274f15995d8ce276944cd2c4c50a523a01abb38a09"
    sha256 cellar: :any,                 monterey:       "ecdff9422d68ac066e12cdc7d5ed3a727adafe28298982cb7f79910d0df44453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f23b804200789a26ee1e152d4015a8f264fad1412665db8a97e6dd1c98ac37"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-X github.comomniscaleimposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"imposm"), "cmdimposmmain.go"
  end

  test do
    (testpath"sample.osm.xml").write <<~EOS
      <?xml version='1.0' encoding='UTF-8'?>
      <osm version="0.6">
        <bounds minlat="51.498" minlon="7.579" maxlat="51.499" maxlon="7.58">
      <osm>
    EOS

    (testpath"mapping.yml").write <<~EOS
      tables:
        admin:
          columns:
          - name: osm_id
            type: id
          - name: geometry
            type: geometry
          - key: name
            name: name
            type: string
          - name: type
            type: mapping_value
          - key: admin_level
            name: admin_level
            type: integer
          mapping:
            boundary:
            - administrative
          type: polygon
    EOS

    assert_match version.to_s, shell_output("#{bin}imposm version").chomp

    system "osmium", "cat", testpath"sample.osm.xml", "-o", "sample.osm.pbf"
    system bin"imposm", "import", "-read", testpath"sample.osm.pbf", "-mapping", testpath"mapping.yml",
            "-cachedir", testpath"cache"

    assert_predicate testpath"cachecoordsLOG", :exist?
    assert_predicate testpath"cachenodesLOG", :exist?
    assert_predicate testpath"cacherelationsLOG", :exist?
    assert_predicate testpath"cachewaysLOG", :exist?
  end
end