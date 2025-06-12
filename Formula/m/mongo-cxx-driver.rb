class MongoCxxDriver < Formula
  desc "C++ driver for MongoDB"
  homepage "https:github.commongodbmongo-cxx-driver"
  url "https:github.commongodbmongo-cxx-driverreleasesdownloadr4.1.0mongo-cxx-driver-r4.1.0.tar.gz"
  sha256 "2abadcdce57cb841218a16c5153d7cdae132f310a72f650879320358feac62ba"
  license "Apache-2.0"
  head "https:github.commongodbmongo-cxx-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^[rv]?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15e5486f75a19657fd653d970140f0322328446fa64f4ecdcb1c9c7f1d8f94c3"
    sha256 cellar: :any,                 arm64_sonoma:  "3ebc5250eb31452205ca3addb07ede68a12844450722678ee5a132cb9fb504a1"
    sha256 cellar: :any,                 arm64_ventura: "c01ddb4060afeef9114a9b7cd15a528b95a7a9b6313cf7c7c204f6bfd6d39854"
    sha256 cellar: :any,                 sonoma:        "acb0f918f5a9a5d779625039e408161c812b93ca6cab4c13eed8ce6fd19840d0"
    sha256 cellar: :any,                 ventura:       "5ae84067b6395912b1713b38e964925f9a66d0c191371346765bfdac0b884f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd90967c83e0cd91a7f7601ddf0a3693d10126f4cd575a5b39927cc5bb66c654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da24e9deab656d631ae582ccaf9b02fb94e56c74f5a67235851dd7132e1eb0d5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "mongo-c-driver"

  def install
    # We want to avoid shims referencing in examples,
    # but we need to have examplesCMakeLists.txt file to make cmake happy
    pkgshare.install "examples"
    (buildpath  "examplesCMakeLists.txt").write ""

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