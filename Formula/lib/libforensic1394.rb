class Libforensic1394 < Formula
  desc "Live memory forensics over IEEE 1394 (\"FireWire\") interface"
  homepage "https://freddie.witherden.org/tools/libforensic1394/"
  url "https://freddie.witherden.org/tools/libforensic1394/releases/libforensic1394-0.2.tar.gz"
  sha256 "50a82fe2899aa901104055da2ac00b4c438cf1d0d991f5ec1215d4658414652e"
  license "LGPL-3.0-or-later"
  head "https://github.com/FreddieWitherden/libforensic1394.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libforensic1394[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a3ae5e839007a8f6cfa3ca2e176285a889085333678c2b5edc095d22326e8aa6"
    sha256 cellar: :any,                 arm64_sonoma:   "466e7d42777a5f74b206d6dfec30b026f6d61ad6a2c0c7e382ab21f9f09b4973"
    sha256 cellar: :any,                 arm64_ventura:  "b6210bfd2d11092c436dcc8732f3848795dc06af4cc97e77b51536fdec7eb4d4"
    sha256 cellar: :any,                 arm64_monterey: "2d9682194518c3caddd083694da02163afa45a5cff22a0855103da7dcccf2efa"
    sha256 cellar: :any,                 arm64_big_sur:  "e199817199f736890486c3667735acf01876563584bdcde56b2671ac85707ba9"
    sha256 cellar: :any,                 sonoma:         "bcfdd8e4b4c60cf26c7334bbe1d94133022a918a892f2fa0da85adde296d76b3"
    sha256 cellar: :any,                 ventura:        "f8b26ec8f4ee3f3e3973330d791c1c2aed6b22277eb2991af7ac97f3192d821d"
    sha256 cellar: :any,                 monterey:       "9a686c1a201ffec188f8748e5f88436097f665549c89c090a99ec94642c268da"
    sha256 cellar: :any,                 big_sur:        "f7405930e26a2b4c9cbe939e6121fe0c20fc3b68015f899e91ba4bba75bdbdbb"
    sha256 cellar: :any,                 catalina:       "4b9746197d1e43ee78530b552e42a6e6cc96908267db1685076f6e283983ab0f"
    sha256 cellar: :any,                 mojave:         "90e2abdc0baef51cfb97b8f9d130f99e2ad5e1eda990f7e6fc29c0e0d1e2f79a"
    sha256 cellar: :any,                 high_sierra:    "5e919cf8bce0747630324f0c203bbd1aef4d7e17d278f42bcbece48da2229c8f"
    sha256 cellar: :any,                 sierra:         "e747c5c6797d48070c4a4199fe38021cd0164a052e14b21005b9caf4a47a6e3c"
    sha256 cellar: :any,                 el_capitan:     "d850e7c3a04b206c6219c75ba0a00723e9a25d0c97831de289320ef0cc076aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cd8c375607751d566f21f16c71a8ed78ec3e4b6511d8ff5f439760c35e2ebd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c997e0a787bfd5280159d056a014bbf9eda79db06cc1873d9126712a5f6ece2f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <forensic1394.h>
      int main() {
        forensic1394_bus *bus;
        bus = forensic1394_alloc();
        assert(NULL != bus);
        forensic1394_destroy(bus);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lforensic1394", "-o", "test"
    system "./test"
  end
end