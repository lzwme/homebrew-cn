class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https:tgui.eu"
  url "https:github.comtexusTGUIarchiverefstagsv1.7.0.tar.gz"
  sha256 "7d40359770e2f8e534a57332c99fd56c72cf79a8b59642676e01394fe05cb1fa"
  license "Zlib"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68d876aecf41558861d2e17ff3ea4aded9773977350015de1b9b0f71cf46e8fe"
    sha256 cellar: :any,                 arm64_sonoma:  "3a24d3b020a457f65ae2dde489267629d190acf8136f330096daf341d5eace2f"
    sha256 cellar: :any,                 arm64_ventura: "aef7806f9a2d5f54c0c052c5b5b2ae1c9447b0492b362e4d6669f0eabd6a7ab5"
    sha256 cellar: :any,                 sonoma:        "4ad63bf9364d7d9b52674b4927448a88a287fcd9d8769fb6daee8f1cac9a3e28"
    sha256 cellar: :any,                 ventura:       "5f96c17afffd6e3497c694e864d9202cbbac1abd3923393258ccfc5427fa524d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46837a2ada4a9bff27b178d758b8ad2c6c78215f7c25837f64f6f7b356bc463"
  end

  depends_on "cmake" => :build
  depends_on "sfml@2" # sfml 3.0 build issue report, https:github.comtexusTGUIissues249

  def install
    args = %W[
      -DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}
      -DTGUI_BACKEND=SFML_GRAPHICS
      -DTGUI_BUILD_FRAMEWORK=FALSE
      -DTGUI_BUILD_EXAMPLES=TRUE
      -DTGUI_BUILD_GUI_BUILDER=TRUE
      -DTGUI_BUILD_TESTS=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <TGUITGUI.hpp>
      #include <TGUIBackendSFML-Graphics.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    CPP

    ENV.append_path "LD_LIBRARY_PATH", Formula["sfml@2"].opt_lib if OS.linux?
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-I#{Formula["sfml@2"].opt_include}",
      "-L#{lib}", "-L#{Formula["sfml@2"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system ".test"
  end
end