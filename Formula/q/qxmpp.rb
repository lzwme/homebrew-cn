class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https:github.comqxmpp-projectqxmpp"
  url "https:github.comqxmpp-projectqxmpparchiverefstagsv1.5.6.tar.gz"
  sha256 "5af37cfbe878284e12babf4cd5f07109198e7e3dd3f1f78dc3eef351b6614a48"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd8a7087985f29caaa0c8444fbdc8f4417de88e21d195695548ea48b787e2435"
    sha256 cellar: :any,                 arm64_ventura:  "f498c6a375de0b020fec37245ce489217a980c67dbbe850233a3ca5cc0470bba"
    sha256 cellar: :any,                 arm64_monterey: "bddd9e2a9d63cd37aa169ad9d44bfca5981b2042a1ccde3c4c2aff851f702203"
    sha256 cellar: :any,                 sonoma:         "4c155bb5752e53f087bd6fcd3d70a9f95ffd132a7c5e801e38c9e3c044248414"
    sha256 cellar: :any,                 ventura:        "d39d2afb79ea9acf19bbe635c62da166253baca055ea77afd923ba0627628bb8"
    sha256 cellar: :any,                 monterey:       "2f77de017c8724222ca932053c94b46219a8a949d3f4e683bb6e78fe4ad1a64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf7606851981491e5eb61240678cf2dd8290917b962a07e70fd54a761217ab3"
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