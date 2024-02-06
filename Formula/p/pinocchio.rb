class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv2.7.0pinocchio-2.7.0.tar.gz"
  sha256 "fbc8de46b3296c8bf7d4d9b03392c04809a1bca52930fab243749eeef39db406"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd2df14becfffb331a76ce5c94ac74b62ba5c53e97a6655dfec2608718fab28a"
    sha256 cellar: :any,                 arm64_ventura:  "64e31b6dde3c7ac460dc43b93ad2a0e1522551866d430286981fbd5816e8d3eb"
    sha256 cellar: :any,                 arm64_monterey: "dd2534d5fcd5ac5c724c78fd59564f7dc52d0ed146f869450b4a3b3775d45dcc"
    sha256 cellar: :any,                 sonoma:         "7ec03479589d5a07c64e32f3cfb03c69e9d9cb344dd31c64f01757e313be0fda"
    sha256 cellar: :any,                 ventura:        "842974be7be262a3a869eb7e7ce991f1b5c58c3da253ad5e2e3fbd2110c75b05"
    sha256 cellar: :any,                 monterey:       "e29817050c882dc25dca91f87ba4befc25a46db779076fe1cf41c51c32a16f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37cd2aa3072f3005cb42a02ec823e725ec3030a6215a5d23dc63c637eac5b4cb"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.12"
  depends_on "urdfdom"

  def python3
    "python3.12"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end