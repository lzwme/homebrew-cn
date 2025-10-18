class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://ghfast.top/https://github.com/orocos/orocos_kinematics_dynamics/archive/refs/tags/1.5.3.tar.gz"
  sha256 "3895eed1b51a6803c79e7ac4acd6a2243d621b887ac26a1a6b82a86a1131c3b6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63bd25562899d50286d71174337878609041305d72923eee5eee59110ed8a688"
    sha256 cellar: :any,                 arm64_sequoia: "481e5428dee3a6c21cd778be800155f2769d068be19d320d725dcebff21de6b8"
    sha256 cellar: :any,                 arm64_sonoma:  "a1eaebcc52b6ac3618084d0da355f989d3c11cd4d9bb9ff5dd4f09decd2536aa"
    sha256 cellar: :any,                 sonoma:        "24a8d96dfaa3d6b7e2721b8d8fa5c5f2727e0a2c49d45fcf5ee22f6ba6a20b11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6939db142728ba767a4fa239a9289740380386aa7ebe03cccfaa177e73a579a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b0ae0640e6e94d36f6d1e87c612cf5a06a56b9f401b3756df6f1e7a3d40941"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    ENV.cxx11
    system "cmake", "-S", "orocos_kdl", "-B", "build",
                    "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kdl/frames.hpp>
      int main()
      {
        using namespace KDL;
        Vector v1(1.,0.,1.);
        Vector v2(1.,0.,1.);
        assert(v1==v2);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end