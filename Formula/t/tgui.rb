class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https:tgui.eu"
  url "https:github.comtexusTGUIarchiverefstagsv1.4.0.tar.gz"
  sha256 "c54af3f201c47d05e0dbae516732c7b278ce70779890157c97c07e00f575ba19"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ccdf54dfa521e3241bbb6e38c1365a82bdfadc27eab392289b375b356de72c9"
    sha256 cellar: :any,                 arm64_ventura:  "a33a9b46b713077cf91cc9f66eeca171106999e42421dc85073a80c8ee1a6fce"
    sha256 cellar: :any,                 arm64_monterey: "1f5242e188ce6005f0703f5338fc45127e0cb904ca141a6c227bdd50af4510a3"
    sha256 cellar: :any,                 sonoma:         "5102fb87643dfc2780ba33f0cde8eb3df9e900ba3db73ca137f692bb4a4dd8cb"
    sha256 cellar: :any,                 ventura:        "4b0e0a46a1f429ae7dd337aa8edc18d41dc7c5225b66e5b54e3e0b3b6987b557"
    sha256 cellar: :any,                 monterey:       "8150baa6c1399848eb9c28943e490037e3a5852f67a4ecc31d0bd5afa3dd4233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d0aee1a212667d86b63c07fab476df0499e1e1b0213265211bc74eb2482543"
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