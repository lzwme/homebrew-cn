class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.23.1.tar.gz"
  sha256 "38c580626b072ed24518e8285a629923c8c4c6d6794b91b3b93474db7fd85cf7"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] }, # driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # userspace/libscap/compat/
  ]
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bf2f9695deefb36e9ecda067f29d4134499aa7cdd6c857c74b40bc80314c74a5"
    sha256 cellar: :any,                 arm64_sequoia: "5efe954a4ff97547b86942b62c1ce5d346bdb649e47e676e1494f23751439a65"
    sha256 cellar: :any,                 arm64_sonoma:  "f9176e3d5a422bd5d3a7f1877b3e7bea15ec50fa027ff4ce803a26089795d9ae"
    sha256 cellar: :any,                 sonoma:        "f53b2e4e2a12a693126e96185025d9e2ef39e7498a4890a1ac3c357868931646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "997b5c2ce454d5eddc87686eb9e86d9312603fd37d24ae9daef035bf0e978764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa384b8a9d032ca4cf0abec8d7a99a55efff9abd7d577ba8198ad7cdc8a2b470"
  end

  depends_on "cmake" => :build
  depends_on "valijson" => :build
  depends_on "googletest" => :test
  depends_on "jsoncpp"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash" => :no_linkage # headers needed for libscap/uthash_ext.h

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
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