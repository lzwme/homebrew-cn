class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.6.1.tar.gz"
  sha256 "e85de632a8cc59e694cc1c29c4861aac9170210fefb39e9d259ff2199af41a86"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f15bde7485c51644e68f1c8c4dc8131a44476883d913d7560a58f00b04b1622a"
    sha256 cellar: :any,                 arm64_ventura:  "f9f9b3418f972bc5b22a606d1fb485119e0cca0076894599fd3aa4d52db997d8"
    sha256 cellar: :any,                 arm64_monterey: "7b355c1611fee52779d3f9f0e26f9690aa0212240c3b5dd4aa9aae86676a9f68"
    sha256 cellar: :any,                 sonoma:         "f8ffb3a37b328960217540089e6d51648dd9c2d3e67245faf999ed95f7e2682d"
    sha256 cellar: :any,                 ventura:        "8b02f97b18cceb5b65bc38f1157955b01a658154df4bb4d4db5065bc1f50de84"
    sha256 cellar: :any,                 monterey:       "26180263f36fdd061b547766d1fed76fc047377230a638c24b99e421a983f38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b346f2d0f999628ee6241203f6181cc0805e8e78c47c3b437951442602475e20"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
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

    (testpath"test.cpp").write <<~EOS
      #include <QXmppQt6QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}qmake", "test.pro"
    system "make"
    assert_predicate testpath"test", :exist?, "test output file does not exist!"
    system ".test"
  end
end