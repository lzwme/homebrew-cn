class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://ghfast.top/https://github.com/stachenov/quazip/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "61c73926d4e98bf4c38becc15ba10437ab2af9e746a3982b86f7d720bd5823b4"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "118ae1186d4190a5766348243b7c2656b4b2875c63e3793b9fd52904d0688a82"
    sha256 cellar: :any,                 arm64_sequoia: "81d3a6092c4c4d6766619abf7ac6ceacdfa64f7e46da720abb8860d890b528d6"
    sha256 cellar: :any,                 arm64_sonoma:  "41d9ec180841dffccfef13497c12c3cfe4080121d19b4451f7549df935074d31"
    sha256 cellar: :any,                 sonoma:        "28492619487288526e9dae263354cbea43ed299ca505a5fe817a27bb11b7448c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47759e5395f3d0eca9302885d4039cc6d023e0a79e0497ee1dd93a983b5acb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe359ef7e9b9e3f425d64f760302eb43249f87cb557cff595b726e9c1352f41"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt5compat"
  depends_on "qtbase"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qtbase"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE        = app
      CONFIG         += console
      CONFIG         -= app_bundle
      TARGET          = test
      SOURCES        += test.cpp
      INCLUDEPATH    += #{include} #{Formula["zlib-ng-compat"].include}
      LIBPATH        += #{lib}
      LIBS           += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    CPP

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end