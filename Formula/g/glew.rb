class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.3.0/glew-2.3.0.tgz"
  sha256 "b261a06dfc8b970e0a1974488530e58dd2390acf68acb05b45235cd6fb17a086"
  license "BSD-3-Clause"
  head "https://github.com/nigels-com/glew.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2609a8eb123eb636047472bd9b50b7dc680cfaf777a3bbc78dc357f6b3b0b92a"
    sha256 cellar: :any,                 arm64_sequoia: "9ec2825bcfd6801de72ccc23615dd322f563b7e8179374daf310bbcbd62f60d0"
    sha256 cellar: :any,                 arm64_sonoma:  "ccda6940121477bff671c1bead8402196779ccef74dbe722a3ed52c44a5ff88c"
    sha256 cellar: :any,                 sonoma:        "28db4c9a63529fafc90f3f63fc487f5c5905faea7ff01561813cd28f16340ff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68c506af46645931cef5812fdd7b515422571a5319c3572e6c5ebf99746fe54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c738eba52384ae853e552d06fb8ab7d8df51a725c6a0c0646356bb7850a2892"
  end

  depends_on "cmake" => [:build, :test]

  on_linux do
    depends_on "freeglut" => :test
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DOPENGL_glx_LIBRARY=#{Formula["mesa"].opt_lib}/libGL.so" if OS.linux?
    system "cmake", "-S", "./build/cmake", "-B", "_build", *args,
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test_glew)

      set(CMAKE_CXX_STANDARD 11)

      find_package(OpenGL REQUIRED)
      find_package(GLEW REQUIRED)

      add_executable(${PROJECT_NAME} main.cpp)
      target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL GLEW::GLEW)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <GL/glew.h>

      int main()
      {
        return 0;
      }
    CPP

    system "cmake", ".", "-Wno-dev"
    system "make"

    glut = if OS.mac?
      "GLUT"
    else
      "GL"
    end
    (testpath/"test.c").write <<~C
      #include <GL/glew.h>
      #include <#{glut}/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    C
    flags = %W[-L#{lib} -lGLEW]
    if OS.mac?
      flags << "-framework" << "GLUT"
    else
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    # Fails in Linux CI with: freeglut (./test): failed to open display ''
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Tahoe running is headless for now, maybe remove this later
    # ("GLUT Fatal Error: redisplay needed for window 1, but no display callback")
    return if OS.mac? && MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end