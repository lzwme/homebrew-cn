class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.10.1.tar.gz"
  sha256 "a9e95847c432cbf9ad36aa6d1596d66aa8f644d6983926457235fb64343bc42c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "c5292bd029b65ed692753b673448f0dfd02f1dd3616662f09bd8b9a6eea6efe0"
    sha256 cellar: :any,                 arm64_ventura: "d5fff6b8d73a8b7926035e5cd89095e2d287706969d6887c575bfe727812b09f"
    sha256 cellar: :any,                 sonoma:        "a40ddbf29f1ecf3d8ce8e19a2457f9883b8041913becb16aab6b5182d790e807"
    sha256 cellar: :any,                 ventura:       "2503b260efbe8630212aec8a1f31279350fa90b318d990fb727f682c8845484a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fff1b3a44d308322051bea804dfa75283d69a23a624e27b9831027aba30b768"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.delete "CPATH"
    (testpath"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath"test.cpp").write <<~CPP
      #include <QXmppQt6QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system "#{Formula["qt"].bin}qmake", "test.pro"
    system "make"
    assert_path_exists testpath"test", "test output file does not exist!"
    system ".test"
  end
end