class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://ghproxy.com/https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-3.5.1.tar.gz"
  sha256 "0da345cda55ec6f6d71afa84cfae55632a16ba0b8b4644f4d0e8a32c9d1117b0"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "737687d78655b6725f243a4f5a362a89be1e0d5a9677dce6e8e01730489e13b5"
    sha256 cellar: :any,                 arm64_ventura:  "956d113cb54e5eb3ba82b10c420ca6cadc03bddeedb035c54cc0ed9192d8a999"
    sha256 cellar: :any,                 arm64_monterey: "3bb93f697b43858b04cc6d59a07aa3ec695a47cb17f8f7bdb3889297ba230d5b"
    sha256 cellar: :any,                 sonoma:         "0bc0b0f4e62c2f0d7693e9c375262f06b86246adee7087fff03be12d3aa6b8a6"
    sha256 cellar: :any,                 ventura:        "b4cfe004615770b6fea461df7ced8218322b08368921cba7a92d9994b53525f7"
    sha256 cellar: :any,                 monterey:       "0bebf9032279186ab07c12356b332845bf77bdd290cb7d90998060559af47159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f388ddfe5e855c0457be5491b6f616cb7846569dc37ca7cd563916fd87db86"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
      # enable DTLS-SRTP extension
      s.gsub! "//#define MBEDTLS_SSL_DTLS_SRTP", "#define MBEDTLS_SSL_DTLS_SRTP"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DGEN_FILES=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    # We run CTest because this is a crypto library. Running tests in parallel causes failures.
    # https://github.com/Mbed-TLS/mbedtls/issues/4980
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "--parallel", "1", "--test-dir", "build", "--rerun-failed", "--output-on-failure"
    end
    system "cmake", "--install", "build"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f bin/"hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install bin/"mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end