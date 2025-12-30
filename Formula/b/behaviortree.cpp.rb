class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://ghfast.top/https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.8.3.tar.gz"
  sha256 "7856d1cc7e7a57fc700602afa5010f5363df32e277c53ae0297e0d418bbe0329"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38fa09006213a158b3e7a44a6dd05e262d0d023ae0023d0c6170cd43cec10af9"
    sha256 cellar: :any,                 arm64_sequoia: "cf394ad3965bf08a9b2781c33c28b25dc18ac6d0a95b8329297b83e347ff08ab"
    sha256 cellar: :any,                 arm64_sonoma:  "52c9a14ae699319b92bdda1b6d6f2b1c6243c61d7d8882e581cc8e5675f2df2a"
    sha256 cellar: :any,                 sonoma:        "5cede9c4f6ccb47cda23d4719aea5a5af46603be4f83ad6307dbf55dcccf12b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e107c4b8565cda9812ec680a2e0af285dee6ab4848601946183171709ab038b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0169f839d35f724efa69e55c57b561cf7437a287d847542f469ac52067a359"
  end

  depends_on "cmake" => :build
  depends_on "cppzmq"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBTCPP_UNIT_TESTS=OFF
      -DBTCPP_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/t03_generic_ports.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lbehaviortree_cpp", "-o", "test"
    assert_match "Target positions: [ -1.0, 3.0 ]", shell_output("./test")
  end
end