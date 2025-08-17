class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.20.0.tar.gz"
  sha256 "4ae6ddb42a1012bacd88c63abdaa7bd27ca0143c4721338a22c45597e63bc99d"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] }, # driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # userspace/libscap/compat/
  ]
  revision 6

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9fd37e2e992070c5fff9255122493a181693a1595f8fb05df44eb1d95e097a88"
    sha256 cellar: :any, arm64_sonoma:  "557995561292a172ca8044ea6ec2c33d04d1b0ce3198ffa8b2e7f73cca9ffc62"
    sha256 cellar: :any, arm64_ventura: "b61104afa02ede646472a16feccf09528fde8d48004e5413b605679780993008"
    sha256 cellar: :any, sonoma:        "da0903dc607214cc832197069b95a1cecba5154b66a70584dc5c01f6f5632b4f"
    sha256 cellar: :any, ventura:       "79b072a4f238d16d7e6f4fd3b03bffb5c58cd3e16d6032a4ece3d43616d8c7a6"
    sha256               arm64_linux:   "53629f47179dc52d61d9faff6041977dda4d4fc8065cdb449535fa07121ed208"
    sha256               x86_64_linux:  "6e5250003333f3757a2eae42711bea5df1b2903adcc1a26ba1b739fdd1af8d17"
  end

  depends_on "cmake" => :build
  depends_on "valijson" => :build
  depends_on "googletest" => :test
  depends_on "jsoncpp"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash" # headers needed for libscap/uthash_ext.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "abseil"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "protobuf"
  end

  def install
    args = %W[
      -DBUILD_DRIVER=OFF
      -DBUILD_LIBSCAP_GVISOR=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DBUILD_LIBSINSP_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCREATE_TEST_TARGETS=OFF
      -DFALCOSECURITY_LIBS_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
    ]
    # TODO: remove on next release which has dropped option
    # https://github.com/falcosecurity/libs/commit/d45d53a1e0e397658d23b216c3c1716a68481554
    args << "-DMINIMAL_BUILD=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/libscap/test_suites/userspace/scap_event.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"scap_event.cpp", "-o", "test",
                    "-I#{include}/falcosecurity",
                    "-L#{Formula["googletest"].lib}", "-L#{lib}",
                    "-lgtest", "-lgtest_main", "-lsinsp"
    system "./test"
  end
end