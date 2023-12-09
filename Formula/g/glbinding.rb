class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://ghproxy.com/https://github.com/cginternals/glbinding/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "a0aa5e67b538649979a71705313fc2b2c3aa49cf9af62a97f7ee9a665fd30564"
  license "MIT"
  head "https://github.com/cginternals/glbinding.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84b1061882c8699d38f1da464f845118939b29c7f510e7e8576465a48787d844"
    sha256 cellar: :any,                 arm64_ventura:  "cfb99ac70297a954286ed89144d7b67f0936325e73a275d50f413bb1a1b350c8"
    sha256 cellar: :any,                 arm64_monterey: "6593ba056f01bc50e5aee54a79db11960f7fca69d7f075f3eedd9a30bab368c4"
    sha256 cellar: :any,                 sonoma:         "c1ecb96e70f096e7e9929850694d5b117de529e0664033a4471284450b6984fb"
    sha256 cellar: :any,                 ventura:        "87e34e3fc861ff0f702815f8740c100115d27cd20039903462693741bc683d6e"
    sha256 cellar: :any,                 monterey:       "fbecccf80effb2edffda114a8fc92469a890a133d8f94cc245c168d35f903112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea31bb6671e1a09ab3e05f1af3a642d20ec758f597ac877bdc1ee846194f71b"
  end

  depends_on "cmake" => :build
  depends_on "glfw" => :test

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Force install to use system directory structure as the upstream only
    # considers /usr and /usr/local to be valid for a system installation
    inreplace "CMakeLists.txt", "set(SYSTEM_DIR_INSTALL FALSE)", "set(SYSTEM_DIR_INSTALL TRUE)"

    # NOTE: Can remove `OPTION_BUILD_OWN_KHR_HEADERS=ON` (at least on Linux)
    # if we add `libglvnd` formula and use it as part of OpenGL solution.
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPTION_BUILD_OWN_KHR_HEADERS=ON",
                    "-DEXECUTABLE_INSTALL_RPATH=#{rpath}",
                    "-DLIBRARY_INSTALL_RPATH=#{loader_path}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/glbinding.h>
      #include <GLFW/glfw3.h>
      int main(void)
      {
        glbinding::initialize(glfwGetProcAddress);
      }
    EOS
    open_gl = OS.mac? ? ["-framework", "OpenGL"] : ["-L#{Formula["mesa-glu"].lib}", "-lGL"]
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding",
                    "-I#{include}/glbinding/3rdparty", *open_gl,
                    "-L#{lib}", "-lglbinding", "-L#{Formula["glfw"].opt_lib}", "-lglfw",
                    *ENV.cflags.to_s.split
    system "./test"
  end
end