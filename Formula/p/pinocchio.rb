class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.20/pinocchio-2.6.20.tar.gz"
  sha256 "2fcead7b1b2f08aa47acd28891e4b204f2e9cc14a4e4c9027168b8c58f9aedd2"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4565652d2dc232fda2c3b4427b4e1d9581839cc509638f3df52d1e87bafe0ee"
    sha256 cellar: :any,                 arm64_ventura:  "47f0089e85010418c67872759b87316ef578966e37897c1375f77a328b1b51fb"
    sha256 cellar: :any,                 arm64_monterey: "25f613d7d086372e9dc0c573d44316a21b13b68f0bfbfbd1fb064ba950e794ac"
    sha256 cellar: :any,                 sonoma:         "f271cdfb4111f48db5f979d5f671a9b8f240588ed228467e94ba8d6f08c9f79e"
    sha256 cellar: :any,                 ventura:        "acaea27737c2873132a03048632b48bab728cf22f5001f5220a654af23f3f8e3"
    sha256 cellar: :any,                 monterey:       "ad9ac82f8963d06b915fef44f636a97a7b93eecd4ae8604bd92445937cf84a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d51b9bc1ca67c125248bc47fd6b074d932427a9ed127c0c140b1f6bba63865d"
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