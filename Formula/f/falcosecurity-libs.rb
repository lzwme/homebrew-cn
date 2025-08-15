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
  revision 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "44111aaa48a0ea3c20c5c5755d8dbfdad2f66fe8443d7d10631b54bf302295c1"
    sha256 cellar: :any, arm64_sonoma:  "744027164770a2cdcd421feb8e9eb9f8067d986c4b7ee29daad643232649a2dc"
    sha256 cellar: :any, arm64_ventura: "b1bc9c1c81588ac8876215a3d0f3a8d9f2fc4ad0c879dd2b146d89d2f76ba7b9"
    sha256 cellar: :any, sonoma:        "3db755a0b1efb72f4c597bc3215271ad76ee3259881bac85f0016b2f50c56216"
    sha256 cellar: :any, ventura:       "25e4ff85f373529b435bc48b6473d0187c50a5d7c77255860baecc186c1d8fc3"
    sha256               arm64_linux:   "cdabffd5e061202749a66066c3215dc8facd9ccf39e9ececd8ccbe18bc9e22f0"
    sha256               x86_64_linux:  "72e09bdae3b7c6aa27f6c2c2f43367a2ad456b6cec6054f011fa080074801df1"
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