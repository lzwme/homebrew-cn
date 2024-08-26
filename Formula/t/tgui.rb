class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https:tgui.eu"
  url "https:github.comtexusTGUIarchiverefstagsv1.5.0.tar.gz"
  sha256 "b95595d10f84077183a86fa52efa6abbf45a96050f8019cb0966813e84431b01"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3faac1d98846f88c860ccdb7ad67eaf9a04e5084324d92b0319147e74102501"
    sha256 cellar: :any,                 arm64_ventura:  "541b10a466a04e1df0245b63c438923282c80fe604f02faf1b4bd3b53549e824"
    sha256 cellar: :any,                 arm64_monterey: "a711e18947f79d449ac31d05b9bc7dfaa5b8784f4d986e49ac082b80131f878a"
    sha256 cellar: :any,                 sonoma:         "890f502405a0c8602d640abf089009f25d1c51a24abb6367036d0a79620470c8"
    sha256 cellar: :any,                 ventura:        "3cb6ec8417100dbabb0fc3644b67cf7ffcb3007983fdefa894f46976eec15e2a"
    sha256 cellar: :any,                 monterey:       "5db8a4e8c5aa1d25b8f7202049a1bf50315b9bbf73df871ac64e1bac4818cec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d472361e1f07167f00c4676aa953b33a1bed24a08b2d10521a1d68f5b6745370"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

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
    (testpath"test.cpp").write <<~EOS
      #include <TGUITGUI.hpp>
      #include <TGUIBackendSFML-Graphics.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system ".test"
  end
end