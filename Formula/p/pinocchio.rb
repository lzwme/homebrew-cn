class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.21/pinocchio-2.6.21.tar.gz"
  sha256 "11131e2a694388f7364f9d8d91615507ad2e13faf58a27a898b930f36f5e3db3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db36ebd2e1cb8a09d6900d7f8f61df4becccb70c3721666c3abdf4adbb6dcf42"
    sha256 cellar: :any,                 arm64_ventura:  "63bf8c4619ac9491d40a4163380e22e2c4ae4a0c5df6792bbe482361485ef850"
    sha256 cellar: :any,                 arm64_monterey: "37b8b47c91537fab72d83833f45d1c1fbf873a011f97b138bbf30b5ee4a3333c"
    sha256 cellar: :any,                 sonoma:         "6c9b3b7a464a4a8798c44254603b40e1c65db9753aa0872432da473cd5c21a73"
    sha256 cellar: :any,                 ventura:        "5747f3cecd810341ddde894dc2790e0f50262e4af54d3fb41eea9b7deaee4220"
    sha256 cellar: :any,                 monterey:       "cf148e237db796daeecbf59eb62f435ad67468aa3ee74cbb453685d1f47a8360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c095eade94bcb933943e72fe150e0d03f3edd268407f290a94f70a3caa5a2b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python-setuptools"
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