class MbedtlsAT2 < Formula
  desc "Cryptographic & SSLTLS library"
  homepage "https:tls.mbed.org"
  url "https:github.comMbed-TLSmbedtlsarchiverefstagsmbedtls-2.28.6.tar.gz"
  sha256 "18cac49f4efef7269d233972bb09c57ace40d992229fa49804e7b10cf0debe43"
  license "Apache-2.0"
  head "https:github.comMbed-TLSmbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(^v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0298ff3ce43da1b7580cabd5e3baee30bff4f76149651c831d30152ce2f0b92a"
    sha256 cellar: :any,                 arm64_ventura:  "2a5f3114ea1022f355c05b045ff4d1b7c3e51129dcbf9f25ebcf91912cc31d7e"
    sha256 cellar: :any,                 arm64_monterey: "645094b885ef53fd146bb5b6858e3dcc45aa8b210bb2fa92e289add78f2ff4ff"
    sha256 cellar: :any,                 sonoma:         "68b601ce21b455cdcd9a087d0d74ad1227489cd4bddb3f0fce0400ae234cb400"
    sha256 cellar: :any,                 ventura:        "998f31369df89db71249d2660b00b0c6a5764cb2d756b7a68d4d3f2dd82ba6f3"
    sha256 cellar: :any,                 monterey:       "07273a16cbad3e987ac43bf888bdb3283f41c00264aefdb9651bba4a2ae5f0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55df4a43e9501867caf1d008eb472563ea4dc090bb65f47e34b19f664ce1d9aa"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    inreplace "includembedtlsconfig.h" do |s|
      # enable pthread mutexes
      s.gsub! "#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    # We run CTest because this is a crypto library. Running tests in parallel causes failures.
    # https:github.comMbed-TLSmbedtlsissues4980
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "--parallel", "1", "--test-dir", "build", "--rerun-failed", "--output-on-failure"
    end
    system "cmake", "--install", "build"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f bin"hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin"benchmark", bin"mbedtls-benchmark"
    mv bin"selftest", bin"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install bin"mpi_demo"
  end

  test do
    (testpath"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}generic_sum SHA256 testfile.txt").strip
  end
end