class BehaviortreeCpp < Formula
  desc "Behavior Trees Library in C++"
  homepage "https://www.behaviortree.dev/"
  url "https://ghfast.top/https://github.com/BehaviorTree/BehaviorTree.CPP/archive/refs/tags/4.8.1.tar.gz"
  sha256 "f3f4fef49976ece5e1d4835ae643f65ebd118b7416f17e5b6527173caab95d98"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4a0daefae8821ac7f0928f00d4fe78255ab221b6b595bff8f32d129cad4a9d8"
    sha256 cellar: :any,                 arm64_sequoia: "054fd45d64d7d0876a734e05714c106f425444f62a1e3436382c435f4c7a75fd"
    sha256 cellar: :any,                 arm64_sonoma:  "d2b1b1ed198414d723c07d0d85d3a504221e91e4472daf1d80a96201862fb70f"
    sha256 cellar: :any,                 sonoma:        "88da3227c234b42ea54df8e0fe695d6f82a0d35b3ca06400803a4b93bfc3fa50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f803bf89a3ec940c615438df36dd968690e74a3de141263befbc6021ed0c28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2718667689bc51ec60624b54f1ebe01356bc1ba7ef019507069d684e8173032"
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