class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "54e0f234ace310a4256dc7d4fc707837f532a509cc3ef2940dacbdc4ebd9ce15"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f375223f2cd618ace49052f54feb3cb9530af2908c1be59620fb9fc2a2c5a77"
    sha256 cellar: :any, arm64_sequoia: "1aeb67d347c8cba73ac3761a6dfa4447068b94936021f8f52f7f4936f71a090a"
    sha256 cellar: :any, arm64_sonoma:  "7b972d41fe7729012c0eb016004106d41e5b0c7542cd31a4a829ea1922e0c73f"
    sha256 cellar: :any, sonoma:        "487257f13be6a87dac32cb0d6d4f2bfbd6440649b58e125830da5fb2f0db4fc6"
    sha256               arm64_linux:   "317323dc069eb40062530a25634542ceefd28e01acace31bd6af041fd21c647a"
    sha256               x86_64_linux:  "e2a08edbc4f9c519132032cadabba5c48ca72e30a9ec179759489550356689f6"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}/osmpbf-outline #{pkgshare}/sample.pbf")
  end
end