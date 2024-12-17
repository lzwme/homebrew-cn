class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv3.3.1pinocchio-3.3.1.tar.gz"
  sha256 "83f7af674d65ec1a03bf46f0230a227ba0cd696d46047a82fe87a93e710837e8"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3abcfaf89ad9a74c4db88d003eb6fd38866804d4a3cea08cb887161e886ee07e"
    sha256 cellar: :any,                 arm64_sonoma:  "62ab3b436bdbaddd4ba078e791b9ae5ce28c48dcc110be2ceed93baf58d06fa2"
    sha256 cellar: :any,                 arm64_ventura: "1c391e37c15acf5620b8a6a78530d2ce4d02760e0c52c138fa8a946dcb59c932"
    sha256 cellar: :any,                 sonoma:        "cc083ab53c2d62e895e517ac9cc19fddad34119153e872341980cc414b5feb1a"
    sha256 cellar: :any,                 ventura:       "900b822cdfb21125f4df7893fc62de4c22cbdedda03ebd2933d429b494d30b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8ab03fa59d988d4433edac3492c230b7ddadd47f2524bb414cb15067a9f8c0"
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