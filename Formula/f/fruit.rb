class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://ghproxy.com/https://github.com/google/fruit/archive/v3.7.1.tar.gz"
  sha256 "ed4c6b7ebfbf75e14a74e21eb74ce2703b8485bfc9e660b1c36fb7fe363172d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9b3bb2a148bbb31068abfb84093dfd3f56fab05b8ed1badd8fda26bab828d80"
    sha256 cellar: :any,                 arm64_monterey: "7267ab542431d4adfd542a1801341f94bc6bcd951869b7d5739e7423526f3653"
    sha256 cellar: :any,                 arm64_big_sur:  "28fe9f0bfb79fbc39048389e2e329e1f84b51a491522c622197c61a54ef835ee"
    sha256 cellar: :any,                 ventura:        "90a9e9ed4c7b5009627bd46e107f3697b310e022e2e1ba0efe05dd0bcb049fd1"
    sha256 cellar: :any,                 monterey:       "8cf43ab558179955f4f110e54ab27083a062070a3e684badfdf0b567eb524548"
    sha256 cellar: :any,                 big_sur:        "7b46f22a641fcec38ca7784157fd876639618d541cf0b1c4ac783d0b9db48627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67f3fbe98944d1758385a4f188435b4b81b7fc5a192fe2c9c1a6e37e6b8d7cb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DFRUIT_USES_BOOST=False", *std_cmake_args
    system "make", "install"
    pkgshare.install "examples/hello_world/main.cpp"
  end

  test do
    cp_r pkgshare/"main.cpp", testpath
    system ENV.cxx, "main.cpp", "-I#{include}", "-L#{lib}",
           "-std=c++11", "-lfruit", "-o", "test"
    system "./test"
  end
end