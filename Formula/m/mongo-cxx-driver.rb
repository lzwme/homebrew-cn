class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-cxx-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-cxx-driver/releases/download/r4.5.1/mongo-cxx-driver-r4.5.1.tar.gz"
  sha256 "e5e0ad56ce87b4654f7f9317188fbb1c446f57e5287502137c22a5b638d66a1b"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^[rv]?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ae7b3cee5646ab05fcf1691b5c31d7aa08f43f4f013ba6a32677da1bbec33364"
    sha256 cellar: :any, arm64_sequoia: "87b21375f3b8a41f97e9290dcb544c4f55faa4bdf3572a94ce2e40703a4ce720"
    sha256 cellar: :any, arm64_sonoma:  "87c01cdbef0072dc45ab21fc0e4176b726ff3b7918c1e184a25679bb1b80beea"
    sha256 cellar: :any, arm64_linux:   "5aaea0d0e45bfddeca3996b70cd67b0bbae6bffcb37f929b5b3157c706cb1930"
    sha256 cellar: :any, x86_64_linux:  "eae990b05d3983b39b7aff6bc5b602cbdd3243055fbb9a7dc77f0a477e874436"
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