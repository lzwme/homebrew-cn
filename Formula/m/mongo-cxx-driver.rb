class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.5.3/mongo-cxx-driver-r4.5.3.tar.gz"
  sha256 "1a597c68517ada097d15cb909f2493a1b570b001164df23941cc33774ba57b7b"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "51a0985e679cab5a3cdccb1915c8f5fd0e9ac15d0d98f8624837d2ab33b916af"
    sha256 cellar: :any, arm64_sequoia: "b6c8ef2cef4797399cb9a04fd8549593b341698d6b78f866ffd020498ce57aba"
    sha256 cellar: :any, arm64_sonoma:  "edd593ed9add14676c073f0a19f22df4635dce0662f284dbad11cd5ab5446303"
    sha256 cellar: :any, arm64_linux:   "fcc84d649a8c3afe5757118bf9ca459365817d21d5c26c5099aa98be950a5890"
    sha256 cellar: :any, x86_64_linux:  "d0ca3e91291b0a1b3820a4483db7d316951e907eeae3ece7ec52a3d2125bc76e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = formula_opt_prefix("mongo-c-driver")
    args = %W[
      -DBUILD_VERSION=#{version}
      -DLIBBSON_DIR=#{mongo_c_prefix}
      -DLIBMONGOC_DIR=#{mongo_c_prefix}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx1 libmongocxx1").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end