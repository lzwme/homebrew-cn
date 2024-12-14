class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv3.3.1pinocchio-3.3.1.tar.gz"
  sha256 "83f7af674d65ec1a03bf46f0230a227ba0cd696d46047a82fe87a93e710837e8"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4db81203d12ee7dab2df84486a3244068de35682b1fe5c5ac574eda2784009e8"
    sha256 cellar: :any,                 arm64_sonoma:  "598ac3c7955de9d36ef452a042b014ceec6e74021e840795be820ab09497fe99"
    sha256 cellar: :any,                 arm64_ventura: "2fbfda3385fe4f0200efdf0e420e0db8746e3c845f5cb199bb776dd489e66692"
    sha256 cellar: :any,                 sonoma:        "5f4e64557b846d3c1a41a35ec2449cd926cc6ddef4787dbb20e408ff0945edd7"
    sha256 cellar: :any,                 ventura:       "894ee486d75aa6876177dc971a2d7822deb94fe731a0ee55afd0e511769c9d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e28d908b4643664b10733561f0e11d20a5c59cc4c426cfcaaf6cbdc9debd62"
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
  depends_on "python@3.12"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

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
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end