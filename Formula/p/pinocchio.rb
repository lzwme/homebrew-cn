class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.20/pinocchio-2.6.20.tar.gz"
  sha256 "2fcead7b1b2f08aa47acd28891e4b204f2e9cc14a4e4c9027168b8c58f9aedd2"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "366311e84cfcf1ae0f12b06135f8708003ef6ba3f0f3cb267bdb46cf6f66b9f1"
    sha256 cellar: :any,                 arm64_ventura:  "140feb32bd7d332e671f6a4426c17401aa5410f631661e2539c38e17edb3acf5"
    sha256 cellar: :any,                 arm64_monterey: "618f283c5e5df0d62dbdcbfd044c706ee18c9c39a327f76ded9b561b37d16bc3"
    sha256 cellar: :any,                 sonoma:         "67eb6b1d7e9f08dc44d5ec8e9a4846423be027c2fda8ad519b89e3afd2528449"
    sha256 cellar: :any,                 ventura:        "b505b3bcb88b0a5e3061bbd904c5dfdf9902f68bf2590cfd2255702ef4f962a7"
    sha256 cellar: :any,                 monterey:       "a65b65f37851582de0db11220303d14aff84c8cab270ad03e535ec35040f202d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9bf1e77ddc80249e6f1ca699b04d06a51e56a258bcaf24af5de8cb6bb67a028"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.11"
  depends_on "urdfdom"

  def python3
    "python3.11"
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