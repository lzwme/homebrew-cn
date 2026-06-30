class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://ghfast.top/https://github.com/stack-of-tasks/pinocchio/releases/download/v3.9.0/pinocchio-3.9.0.tar.gz"
  sha256 "60553630d83de492bc0cf1126add2acc591c87f1bc8ea7f70693e7563fc103a3"
  license "BSD-2-Clause"
  revision 4
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "897077bb3831732264979cce5d37f9245caa2147d7588521727c217107ab6dbe"
    sha256               arm64_sequoia: "70f57d18182795dcc31bb5bb14837d27544c612ed62c61a953914cd2edf4e9a0"
    sha256               arm64_sonoma:  "75c11fa9d1bade8ea65872d3143fb8b5a56a70c421da45aad484de0b9a18e678"
    sha256 cellar: :any, sonoma:        "a6d21087967370318b95e49d643e657a2880941a9bce894b2753bb31a059ba35"
    sha256 cellar: :any, arm64_linux:   "33999aa20a653a680cb5c87002f2bf0f97584c1de09dbf31b7c404d6f1692211"
    sha256 cellar: :any, x86_64_linux:  "aa6e31ea71b0eb715c4accf2183c968449bb7e43b4d4b3a0aeae24b35ef69ce2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "coal"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "python@3.14"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Apply open PR to fix build with eigen 5.0.0
  # PR ref: https://github.com/stack-of-tasks/pinocchio/pull/2779
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/cd06f874671f44507777663fe36d643035d20300.patch?full_index=1"
    sha256 "f3bde3a9c1a094aff88ea11d767651f11a245d24857f375f4fed20f0abf58cbf"
  end
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/a25d222611a695a209375a27780cef5579c0e50a.patch?full_index=1"
    sha256 "1c54ce6f2b0ce1eb4f804794ac3ce812866cdfa784c521beb555d463a332dca2"
  end
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/2dd5857b4fb418de3b37c98d49b5f31fc59c5bb3.patch?full_index=1"
    sha256 "8a6b1f107af678de080b64f95e4525044e50f31c95a91cf0d892fdd09bdaa2c3"
  end

  def python3
    "python3.14"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_WITH_COLLISION_SUPPORT=ON
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{rpath}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end