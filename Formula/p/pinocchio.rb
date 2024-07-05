class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv3.1.0pinocchio-3.1.0.tar.gz"
  sha256 "e624484077eee3183e20443ab0373205bb832a2597241531705116fa9f07016a"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98a3c0ea6c2bc618472e6bd0dbcfe514c0a576847b146a92e9d6c7c7f33bdfae"
    sha256 cellar: :any,                 arm64_ventura:  "af196ee5734adc1fdc299605cde41dffd5c2e0dff95c27b84becd9421ac6f7b9"
    sha256 cellar: :any,                 arm64_monterey: "b2209b27023e106e58656df4d6fdc6a00c2bf78a7dfee62417d5ad29a8cff0ed"
    sha256 cellar: :any,                 sonoma:         "b09dc337e8ae241888bdb87c745dda8772c0500fa11e4cd64b119f76e5ab71ed"
    sha256 cellar: :any,                 ventura:        "5e6c14733c7a29266289ef509d691bedd95eb6434447a76e26e714363b88d1a8"
    sha256 cellar: :any,                 monterey:       "d71b8867f41812b5c5efa2da76ce7c9c043b2828ae9bf28446050472ec5d80a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739773f659e5e848ceff7107c12f903916fb62ecb1fdeb1af483d5f86803a3d1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
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
    system python3, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end