class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https:stack-of-tasks.github.iopinocchio"
  url "https:github.comstack-of-taskspinocchioreleasesdownloadv2.7.1pinocchio-2.7.1.tar.gz"
  sha256 "fd50b72f9f32c14c8f9e7712d9abe077c154d2072e780faf12cc132cc198815f"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstack-of-taskspinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aac850f371c27f55671e1d990118444cb9e446725b34733b2c1ab431b009954b"
    sha256 cellar: :any,                 arm64_ventura:  "0930085d52ff606453ba155242e00c98c6695e27dae41dece5857186fd9a579e"
    sha256 cellar: :any,                 arm64_monterey: "8d5d9e7ff52538196585a3dc1d5cba69305a6747801c8f1ab687171f3aa33c0c"
    sha256 cellar: :any,                 sonoma:         "48a55da307abc0d2569f685a8364c35e4c9ed08ed18321e6eb1c8c906dd85f54"
    sha256 cellar: :any,                 ventura:        "cec59d60b90aba99e780a0cfc0cab0ffaed095b055347f22937ea3a57a3f74ca"
    sha256 cellar: :any,                 monterey:       "658aaf710ab43fe5c7619404535a2deb8f659a0647ba84a03fd8a566336f2fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cc93c5115abfa32ccc413e92cb7d0741571a6fb2caa6dfaefe6b74e8162dce"
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