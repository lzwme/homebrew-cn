class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a706fdae046b617c79d62c63f421bf151fc4b71ac9a5090ec2dd7fb3eb63038d"
    sha256 cellar: :any,                 arm64_sonoma:  "e1365c155a6d48075e56f79aa8f6c1183deae82328eafffb449a6f2250894147"
    sha256 cellar: :any,                 arm64_ventura: "a8a6b13ed7138c459927a574663b6e106ed1b8c64ceaf09209691136a5dc52c5"
    sha256 cellar: :any,                 sonoma:        "ff4c3b2064b9b42b121af46950b1a7a315fcef9141361b7f698dd574f1c17ca8"
    sha256 cellar: :any,                 ventura:       "9977bb32528de863f26c96b665fef866464afd6b1e29a6c0cfd646b517470824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc751c2903bf4df4f2aaef93a3da1af0c65dccafa4eeaa209f50f698b7ebd0c"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resourcessample.pbf"
  end

  test do
    assert_match "OSMHeader", shell_output("#{bin}osmpbf-outline #{pkgshare}sample.pbf")
  end
end