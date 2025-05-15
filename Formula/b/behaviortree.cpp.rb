class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https:www.behaviortree.dev"
  url "https:github.comBehaviorTreeBehaviorTree.CPParchiverefstags4.7.1.tar.gz"
  sha256 "7fccfad1bbe6fd0b3dffff0e439fcd508ca2983deec1b7447a5c8d66540dd91c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4c88258807c03dfa42972d969926a0ca73e47cfb4255f2671899530d5f5b697"
    sha256 cellar: :any,                 arm64_sonoma:  "d966f3f5496bbf6dd1e5814f0efb80692046c9e88ec5be3cae349b8a2f51bcc4"
    sha256 cellar: :any,                 arm64_ventura: "762a8cf30054ceac0d39c0fc660619a1293a6c1d93d2bd79a5dab2f65a09e701"
    sha256 cellar: :any,                 sonoma:        "d29e1b0f4dc31024d23c858c0dc398b92b7e81699685bcbb2925dfcd53d9c14c"
    sha256 cellar: :any,                 ventura:       "33194549fe30d82462d9544ee3d337c3561c9ebb0297c0f0904ce5f72c78bae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daada1bfe756c6bb71bcdf3f0f7090ae2436172c1f7bdb6d6890937771722410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9709dc54ea399939a8ebf959cb9d10b8766f6a05f0284fb3de1e3e037818b7b0"
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
    cp pkgshare"examplest03_generic_ports.cpp", testpath"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lbehaviortree_cpp", "-o", "test"
    assert_match "Target positions: [ -1.0, 3.0 ]", shell_output(".test")
  end
end