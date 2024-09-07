class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https:wiki.openstreetmap.orgwikiPBF_Format"
  url "https:github.comopenstreetmapOSM-binaryarchiverefstagsv1.5.1.tar.gz"
  sha256 "183ad76c5905c7abd35d938824320ffb82d9ca8987796018f2da8380b51cdac2"
  license "LGPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6bb2f463c8057747690621b4e869050d29c6e0bf8e64b1dcd41226907cab110"
    sha256 cellar: :any,                 arm64_ventura:  "f84365ad813200d435f6368b3c5ce55b618210ad5d0f573804b4861b9249149f"
    sha256 cellar: :any,                 arm64_monterey: "c9cf203ec895aecbd958f5ebe16e1a6b596e6859ffac89f8726d220d2a27994e"
    sha256 cellar: :any,                 sonoma:         "8ac084b6abcdc098f4d73b982966d338c011ef137dfca018d139e52e40d0b342"
    sha256 cellar: :any,                 ventura:        "3f4a74f87a755821abc69c51ce177cb4671719695be30611cc24b8ee332b63fd"
    sha256 cellar: :any,                 monterey:       "32c590ab44d2dbe99962b264ca8d4c0d950013e51805540a5cba84850a471a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3800b90519f58f7c6b0f37a34bb0fb30d70e183216c24b981e5a8a6d5a6eead"
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