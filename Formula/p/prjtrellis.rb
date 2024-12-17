class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https:github.comYosysHQprjtrellis"
  url "https:github.comYosysHQprjtrellisarchiverefstags1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2284a16c05b6deba01beea66a7406d012ed14f6cc6fd8ba57a7e4c35ea1e9742"
    sha256 cellar: :any,                 arm64_sonoma:  "0d67a5e850ca2a27fa68017eb0b7897e4d508ba710fd8d91602b8f3d99c36604"
    sha256 cellar: :any,                 arm64_ventura: "05808fa399d5c63c80d0ad61e82ea947c3b8f9aec9d15990dc6f9c2140dcccb3"
    sha256 cellar: :any,                 sonoma:        "f6677f6b112fdaf78929410222cbe71941baf53fada211608ca4a588cac9d78f"
    sha256 cellar: :any,                 ventura:       "c4174aed3e7ed2c538fea626ac85fac270d6a33237a79e3aa3d9bdb59f467706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e2c70077a29cf4bbc619fc9a6086a71b7e7e6156b4d85910427c9ffd16d4cf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.12"

  resource "prjtrellis-db" do
    url "https:github.comYosysHQprjtrellisreleasesdownload1.4prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"
  end

  def install
    (buildpath"database").install resource("prjtrellis-db")

    system "cmake", "-S", "libtrellis", "-B", "libtrellis",
                    "-DCURRENT_GIT_VERSION=#{version}", *std_cmake_args
    system "cmake", "--build", "libtrellis"
    system "cmake", "--install", "libtrellis"
  end

  test do
    resource "homeebrew-ecp-config" do
      url "https:kmf2.trabucayre.comblink.config"
      sha256 "394d71ba416517cceee5135b853dd1e94f99b07d5e9a809760618fa820d32619"
    end

    testpath.install resource("homeebrew-ecp-config")

    system bin"ecppack", testpath"blink.config", testpath"blink.bit"
    assert_predicate testpath"blink.bit", :exist?

    system bin"ecpunpack", testpath"blink.bit", testpath"foo.config"
    assert_predicate testpath"foo.config", :exist?

    system bin"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_predicate testpath"pll.v", :exist?

    system bin"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_predicate testpath"ram.hex", :exist?
  end
end