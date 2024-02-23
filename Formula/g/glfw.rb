class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https:www.glfw.org"
  url "https:github.comglfwglfwarchiverefstags3.3.10.tar.gz"
  sha256 "4ff18a3377da465386374d8127e7b7349b685288cb8e17122f7e1179f73769d5"
  license "Zlib"
  head "https:github.comglfwglfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6c1b3d59da4e9ccabb5cd56851ef3ece630a463b15bec93d19a097adc91d9565"
    sha256 cellar: :any,                 arm64_ventura:  "ed942a348fe26ea86a07d62ee5e257a0d9cfa9abca854b785036c83ee9ebe74c"
    sha256 cellar: :any,                 arm64_monterey: "44d41bfdc3d45687b7f9a5f60a187df384af22c61396eac56b0c5d895a8bb0a3"
    sha256 cellar: :any,                 sonoma:         "9b8c0446780356282c3cae3c91081bf4a43765dfa0855cad5aa6dbbdff37aa80"
    sha256 cellar: :any,                 ventura:        "1941743dec7e2e025c97fa654216b542ac1687aa252d6f881d14a2f1c6284289"
    sha256 cellar: :any,                 monterey:       "5dd5cd2335f92401adf743820a59e21fe074062830d6eaeb218810a64d70ef23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d03089b82a7946ad01e029bbff47f34d32d1a080d719781d71392238a3cc3242"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFWglfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system ".test"
  end
end