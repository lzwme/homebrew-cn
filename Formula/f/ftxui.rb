class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://arthursonzogni.github.io/FTXUI/"
  url "https://ghfast.top/https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "28da2c3389440af869f8781679b537c4a3d5b4df42aeab54eb1564d1b61af864"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c623489cb96f88629ac579a9b9521178b204fb8d824621037dedd9218f18a613"
    sha256 cellar: :any, arm64_sequoia: "40347971d8a9abceb0b38b473ab4f6a030cf47172f4b9fdec63b27ad0cb49b6e"
    sha256 cellar: :any, arm64_sonoma:  "ff39428696d5ab6a82fd8751a885e4e23e9dc5de16c550717e8375a5db5424a4"
    sha256 cellar: :any, sonoma:        "e3333eed3203fa2b4a2f3d7d7930c125d83e78033ad526f650a95eff946164de"
    sha256 cellar: :any, arm64_linux:   "aede083617e80d989efda395a14dcb38cb49b6b9ff767bd41e250eaf7b3cc510"
    sha256 cellar: :any, x86_64_linux:  "d8693ab337fd95c0f719041c4ba7e2d6f2a7860f12ab0fd9373e22f165a18899"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFTXUI_BUILD_DOCS=ON
      -DFTXUI_BUILD_EXAMPLES=OFF
      -DFTXUI_BUILD_TESTS=OFF
      -DFTXUI_QUIET=ON
      -DFTXUI_ENABLE_COVERAGE=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ftxui/dom/elements.hpp>
      int main() {
        using namespace ftxui;
        auto summary = [&] {
        auto content = vbox({
          hbox({text(L"- done:   "), text(L"3") | bold}) | color(Color::Green),});
          return window(text(L" Summary "), content);
        };
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end