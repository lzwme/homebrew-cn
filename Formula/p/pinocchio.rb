class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv2.6.21pinocchio-2.6.21.tar.gz"
  sha256 "11131e2a694388f7364f9d8d91615507ad2e13faf58a27a898b930f36f5e3db3"
  license "BSD-2-Clause"
  revision 2
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4f2a82ffe7385004019c36e0f3f39660cced34c3e54c11996f1843464533f7d"
    sha256 cellar: :any,                 arm64_ventura:  "589dbed761304ac485d47f7fd43a42d4a9ddf04cbb3c3125c181a2723d38ad68"
    sha256 cellar: :any,                 arm64_monterey: "fb0f89682afa4e71aa7ac41a4f68876d56f63b73b8c87d461a6f9b00d93518b9"
    sha256 cellar: :any,                 sonoma:         "731ad84020c2e458374070bea7b0dbc473cdf7a8c2b727c3b8c5ab627798f9f7"
    sha256 cellar: :any,                 ventura:        "fc8298d27a76afcd2b07ab801b328479dedf73231a0fd255e68f595fa4086804"
    sha256 cellar: :any,                 monterey:       "3c9f892d968d3f0e1121d5fd152a07b222fc71191724ba0d06323cb5e4a996db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ef703e11e7891ee84d2169c5695ae7fb321c10329134143446cb54557f5715"
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