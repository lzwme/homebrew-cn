class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://ghfast.top/https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.8.0.tar.gz"
  sha256 "7464badd36d322b4eb459f32b2ae8ca05a3bb16dbd61ac03f1730cef6347f770"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bdc2c546b85ea2f55919a0767fd92c232a31ef55868522ee6e93a424d8339f4"
    sha256 cellar: :any,                 arm64_sequoia: "3ea237d5cb825ebeb66ae1c8109cb508239516b267b0cb7f3a6fbc22bb62a270"
    sha256 cellar: :any,                 arm64_sonoma:  "29dd96fca3c082a5e6a64f6836eff0a20ca7748a89c72c3dcef3d3b1e8843f15"
    sha256 cellar: :any,                 sonoma:        "9221bd11326edfedb6f392e71dacef9428c7a66667d1f8a2e6629b623031b37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39715e5eed9e3e0db921de52a009f770674cc5a4fa4ba8806f14d36fb63490b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ac6de94d65f1f7ecb681a00f3ead28fa2a5a37fbe1ee02747e92d7bdfda03e"
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