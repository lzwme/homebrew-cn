class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https:github.commongodbmongo-cxx-driver"
  url "https:github.commongodbmongo-cxx-driverreleasesdownloadr4.0.0mongo-cxx-driver-r4.0.0.tar.gz"
  sha256 "d8a254bde203d0fe2df14243ef2c3bab7f12381dc9206d0c1b450f6ae02da7cf"
  license "Apache-2.0"
  revision 1
  head "https:github.commongodbmongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^[rv]?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "076899436db520e9cf26e596fb15e6b55bc91a241941a0e72ca50a03ced7f4e4"
    sha256 cellar: :any,                 arm64_sonoma:  "8f0a2e351df8f50bde18a2cb1269f7809a61e7295bd427ee8306d4b2abd8135c"
    sha256 cellar: :any,                 arm64_ventura: "9f485a724048cec2715471819a53c3ba859c54a6c123f582ee1c64fb773d2660"
    sha256 cellar: :any,                 sonoma:        "7f9b6811d5a8dee9177503d3f7026ef05e51ca89d343ab2dc04dfd5e8c7e278c"
    sha256 cellar: :any,                 ventura:       "0e00e45fe2dd1a90ee4ad14e9012f82aed82f5acd88450f2748b83e3b9f82150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01b0c332699922df9f0e959bbaf6e49af29800a4fcffcd51a2a54aed2929eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7613b42a1e10964b6df62cf8d337feccadda20b5ccb3c8fc34b6c8de1575d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver@1"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examplesCMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath  "examplesCMakeLists.txt").write ""

    mongo_c_prefix = Formula["mongo-c-driver@1"].opt_prefix
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
    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare"examplesbsoncxxbuilder_basic.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    system ".test"

    pkgconf_flags = shell_output("pkgconf --cflags --libs libbsoncxx libmongocxx").chomp.split
    system ENV.cc, "-std=c++11", pkgshare"examplesmongocxxconnect.cpp",
                   "-I#{pkgshare}", *pkgconf_flags, "-lstdc++", "-o", "test"
    assert_match "No suitable servers", shell_output(".test mongodb:0.0.0.0 2>&1", 1)
  end
end