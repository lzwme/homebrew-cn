class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https:wiki.ros.orgurdfdom_headers"
  url "https:github.comrosurdfdom_headersarchiverefstags1.1.1.tar.gz"
  sha256 "b2ee5bffa51eea4958f64479b4fa273881d82a3bfa1d98686a16f8d8ca6c2350"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c343415f07893bdee8693c0015e04a1c7b70dc79d2a8e1b8fb6da74364664af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <urdf_modelpose.h>
      int main() {
        double quat[4];
        urdf::Rotation rot;
        rot.getQuaternion(quat[0], quat[1], quat[2], quat[3]);
        return 0;
      }
    EOS
    system ENV.cxx, shell_output("pkg-config --cflags urdfdom_headers").chomp, "test.cpp", "-std=c++11", "-o", "test"
    system ".test"
  end
end