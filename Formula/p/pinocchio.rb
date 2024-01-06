class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv2.6.21pinocchio-2.6.21.tar.gz"
  sha256 "11131e2a694388f7364f9d8d91615507ad2e13faf58a27a898b930f36f5e3db3"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3b06543bfadd2a060604db52a21ce94c96a9b464d5fe58d57da9cf3584e5338"
    sha256 cellar: :any,                 arm64_ventura:  "fee5f3c00578f3fe6a3086c8bdfb70535852b1229940a744f62f2fd269ebe265"
    sha256 cellar: :any,                 arm64_monterey: "0eebe94411dc66cd5f8c1cbd319b8830f188ee9f202f5ca069d85c39293258f3"
    sha256 cellar: :any,                 sonoma:         "0b76886db6bd7d793689a6c1d84b2027625e436e6973eba2af8239ad84f97420"
    sha256 cellar: :any,                 ventura:        "556e5666d444e2caaebe886d8158b98fc78de7d67e402f600d4695aad5594dc0"
    sha256 cellar: :any,                 monterey:       "ed434a168aef54a133ef3aed765f10399d740d9d3a2fde1cbc619cc13ab61d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761aeeb8512baf9bdeba70adf661865d6980a680d209eaaa52f3f6116855fb02"
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