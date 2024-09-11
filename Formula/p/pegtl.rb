class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https:github.comtaocppPEGTL"
  url "https:github.comtaocppPEGTLarchiverefstags3.2.7.tar.gz"
  sha256 "d6cd113d8bd14e98bcbe7b7f8fc1e1e33448dc359e8cd4cca30e034ec2f0642d"
  # license got changed to BSL-1.0 in main per https:github.comtaocppPEGTLcommitc7630f1649906daf08b8ddca1420e66b542bae2b
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "921ed447ab7482f1ecd1890f8953309e6078e2a9ebff25cb44935ada1891c206"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    args = %w[
      -DPEGTL_BUILD_TESTS=OFF
      -DPEGTL_BUILD_EXAMPLES=OFF
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm "srcexamplepegtlCMakeLists.txt"
    (pkgshare"examples").install (buildpath"srcexamplepegtl").children
  end

  test do
    system ENV.cxx, pkgshare"exampleshello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output(".helloworld 'Hello, homebrew!'")
  end
end