class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.25.1.tar.gz"
  sha256 "fdd41357003fc8cd25dd1af03afb3a9b93b52978aef9ea7b5f242941bca11a70"
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
    sha256 cellar: :any,                 arm64_tahoe:   "41dbee226e045a46578c533ddb8345a616608b22436b268fd7be73549d289d98"
    sha256 cellar: :any,                 arm64_sequoia: "7cdcf0f7e07208c5fe3d943e9aeb7e052ea2339831e15ec5495b3357a310dac7"
    sha256 cellar: :any,                 arm64_sonoma:  "38728f4152fc02b71823da6ac325bbd65aea9e58e061c0ad479c3ff6e0c8e012"
    sha256 cellar: :any,                 sonoma:        "c269e662560e1972255614b19e036815630885310870ba95a86224115e4b2c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e73250139c32c5ef05b025ff09aa64e5b82596255a9b91c65370c755a31cc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c554082745be75f3e5894d2fc6c6b7307a3bb2fe5ddaa97309f434fa85827536"
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