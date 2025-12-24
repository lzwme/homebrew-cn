class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.23.0.tar.gz"
  sha256 "3c492398193a492d3fbf563af7346e500fb4e6480f1b1b9d263a5647d6f68020"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] }, # driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # userspace/libscap/compat/
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1b0ac366537608166b8e7f73ee33ff6da0158d0ed2ca1d91618ddbd8f2d6d2e"
    sha256 cellar: :any,                 arm64_sequoia: "503bb6c3c25984532d8a9fa6c37f16d0defb3f466ec374e656a1182ea83b0216"
    sha256 cellar: :any,                 arm64_sonoma:  "60ba359b3bcd6ef93e7903e3fb12e2b14f2a6cc5fb6a34450cc10f6b285a7ea4"
    sha256 cellar: :any,                 sonoma:        "e13f4946478ca8dea582e594c5ad9788338413ecc3943f25333d56921d2575ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b14d0e6a6a9ee8783711a88b9de6409d1d02c0e919c72bf28488138551e14db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c012cc1cb8c63d969a0d466acc649d86c44f84e2dda99611f28c774e32128a"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/libscap/test_suites/userspace/scap_event.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"scap_event.cpp", "-o", "test",
                    "-I#{include}/falcosecurity",
                    "-L#{Formula["googletest"].lib}", "-L#{lib}",
                    "-lgtest", "-lgtest_main", "-lsinsp", "-lscap_event_schema"
    system "./test"
  end
end