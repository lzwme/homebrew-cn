class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https:www.ospray.org"
  url "https:github.comosprayosprayarchiverefstagsv2.12.0.tar.gz"
  sha256 "268b16952b2dd44da2a1e40d2065c960bc2442dd09b63ace8b65d3408f596301"
  license "Apache-2.0"
  revision 1
  head "https:github.comosprayospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8f0c2b7fc94018818e368fe539e533f58cb7bb6223fbedb08118153f57366564"
    sha256 cellar: :any, arm64_ventura:  "3669abca9f9a4920fe97d08c318bb24ed7a42e203c40d814f42860f2f9054943"
    sha256 cellar: :any, arm64_monterey: "62bbd8250633c21c5be47eca0087c81d1066b1f07ee33c77772c059f8158a707"
    sha256 cellar: :any, sonoma:         "40dcc27c71be76c8894f02fb0721134c028f0d43da61356c809e10685eb47cf2"
    sha256 cellar: :any, ventura:        "4459fbe2d70bdb75452b9933292d24cf1253d8430465f0d85fad23f82baffe06"
    sha256 cellar: :any, monterey:       "874d511bb6038cd75a206d2d2ab0027baea27abfc3512dadc601d629b33d739e"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https:github.comosprayrkcommonarchiverefstagsv1.11.0.tar.gz"
    sha256 "9cfeedaccdefbdcf23c465cb1e6c02057100c4a1a573672dc6cfea5348cedfdd"
  end

  resource "openvkl" do
    url "https:github.comopenvklopenvklarchiverefstagsv1.3.2.tar.gz"
    sha256 "7704736566bf17497a3e51c067bd575316895fda96eccc682dae4aac7fb07b28"

    # Fix CMake install location.
    # Remove when https:github.comopenvklopenvklpull18 is merged.
    patch do
      url "https:github.comopenvklopenvklcommit67fcc3f8c34cf1fc7983b1acc4752eb9e2cfe769.patch?full_index=1"
      sha256 "f68aa633772153ec13c597de2328e1a3f2d64e0bcfd15dc374378d0e1b1383ee"
    end
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <osprayospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system ".a.out"
  end
end