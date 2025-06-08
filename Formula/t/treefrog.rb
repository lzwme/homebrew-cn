class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https:www.treefrogframework.org"
  url "https:github.comtreefrogframeworktreefrog-frameworkarchiverefstagsv2.11.0.tar.gz"
  sha256 "67cbd3d2ee9810007feb97694c6eb1f7ddf9040210e69ca3adc7995c96f63df9"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comtreefrogframeworktreefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:  "75f00345bd6ef254cc732ee27d3cca4cb2c2b4d3ec1a0f0c9c5c25b5a8139d96"
    sha256 arm64_ventura: "65fafc887042f7679a72d01001c9853215e9cbe733e36d14b2d33e8e7fa6081e"
    sha256 sonoma:        "fa26e8cbf7cfea256f3ccdd566f118c052c29a4156541d631fdb007fce827ea1"
    sha256 ventura:       "2c38ae3a6318816e71031118ba8ce44543b3a6328a7e4cef14ff3dd5a4d38dcb"
    sha256 x86_64_linux:  "e442623cd0ab40cf43d2ac0da448f47fbb2d8cd0373b5e75405e794cff7dc1f8"
  end

  depends_on "pkgconf" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver@1"
  depends_on "qt"

  def install
    rm_r("3rdparty")
    # Skip unneeded CMake check
    inreplace "configure", "if ! which cmake ", "if false "

    system ".configure", "--prefix=#{prefix}",
                          "--enable-shared-glog",
                          "--enable-shared-lz4",
                          "--enable-shared-mongoc"
    system "make", "-C", "src", "install"
    system "make", "-C", "tools", "install"
  end

  test do
    ENV.delete "CPATH"
    system bin"tspawn", "new", "hello"
    assert_path_exists testpath"hello"
    cd "hello" do
      assert_path_exists Pathname.pwd"hello.pro"

      system Formula["qt"].opt_bin"qmake"
      assert_path_exists Pathname.pwd"Makefile"
      system "make"
      system bin"treefrog", "-v"
    end
  end
end