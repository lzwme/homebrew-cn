class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.9.0/mongo-cxx-driver-r3.9.0.tar.gz"
  sha256 "09526c61b38f6adce86aa9ff682c061d08a5184cfe14e3aea12d8ecaf35364a2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd87350d4179a6f5a9335bcc9b5d661329baa820153c636126d3cbb93b7ac523"
    sha256 cellar: :any,                 arm64_ventura:  "799b6dd7e54fcfa23ab6b2a2b9013fe610c22e5ed16f11e330dca9ef4382f2d1"
    sha256 cellar: :any,                 arm64_monterey: "83a1bca7be21f77c912a16ef5d4b14e8a1b566d57bb255aa310463b9334e5594"
    sha256 cellar: :any,                 sonoma:         "7eb9bbd21a31253b4fbbec08435dccf96a1a2a46b2a0263cb84a74cff1a49f78"
    sha256 cellar: :any,                 ventura:        "dc61fefd861d9abe7bb075391f3cf3cd88807897417d332b48a4615393764d58"
    sha256 cellar: :any,                 monterey:       "3a9288a74b4b4be9156f23cdb8abcf1f19ac07c7e07f4a255e104270e4faf05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e6c8424ae5c01be98cc06fa3f53e8cbad6eac392c5ea975d5c0ebb4cff66c0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examples/CMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath / "examples/CMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver"].opt_prefix
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
    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/bsoncxx/builder_basic.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    system "./test"

    pkg_config_flags = shell_output("pkg-config --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare/"examples/mongocxx/connect.cpp",
      *pkg_config_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers",
      shell_output("./test mongodb://0.0.0.0 2>&1", 1)
  end
end