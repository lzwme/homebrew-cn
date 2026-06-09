class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.25.3.tar.gz"
  sha256 "72af77e5cc3f0c20011f6623d7b5558113f1a9ca65df1ece9d97c09ada870e2e"
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
    sha256 cellar: :any, arm64_tahoe:   "96931708ec5d23c00919fcea35300979f5320bcf606f0f76a36c3057927dd903"
    sha256 cellar: :any, arm64_sequoia: "bccea6b28e4d61dfb4b7fc92fc939fd958d83506d7e694f27cee79d7d9088968"
    sha256 cellar: :any, arm64_sonoma:  "a315030a0081a2b55916ba18fcf9425b4dbc6b8ef1526b8660afde7a9a95aca4"
    sha256 cellar: :any, sonoma:        "7dd3485ccf89c976f7f5f59bba34e18baec8d85b0fb1bcc4d0c9eb7a81d6aada"
    sha256 cellar: :any, arm64_linux:   "04561a112ffaf56309fadc1940f9111e9bac34a6594657fa0e2de54c14b6132a"
    sha256 cellar: :any, x86_64_linux:  "a64d02e4f67b8e226d47adfd1418eff762ff9ecb8e6b46923b41924f05622845"
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