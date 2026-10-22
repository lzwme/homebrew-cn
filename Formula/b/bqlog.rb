class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://ghfast.top/https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.7.1.tar.gz"
  sha256 "39678545fe7322d2193ff5e22a6e99937de1b6dc01a0531f31440991fa4881a9"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0c76a92c7b2343021a65c167597b8a27a68d264c37e004a123136e6b2fb029ba"
    sha256 cellar: :any, arm64_tahoe:       "07ef057402107d3fe8125216f9a0580c045529046317fdc00de40deff8166a5a"
    sha256 cellar: :any, arm64_sequoia:     "e2895298180e38ba48a37b830c4e0bec5bdcf1c49eb802058c3f9e81fd410bcf"
    sha256 cellar: :any, arm64_linux:       "e3fdc005c9a41f0d2c8178bee9eca1675b99ec687369a45d41667b185e923922"
    sha256 cellar: :any, x86_64_linux:      "81308925f0a4d59d0b300bce23f29f705c0d17d29c7196cb058f9b0ecf564f33"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[-DBUILD_LIB_TYPE=both -DBQ_WERROR=OFF]
    # Build for the native architecture instead of upstream's universal default
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Each tool installs another copy of the library's docs directory
    rm_r share.glob("doc/BqLog_*/docs")
  end

  test do
    (testpath/"test.cpp").write <<~'CPP'
      #include <bq_log/bq_log.h>

      int main() {
        bq::log log = bq::log::create_log("test",
          "appenders_config.file.type=compressed_file\n"
          "appenders_config.file.file_name=log/test\n"
          "appenders_config.file.levels=[all]");
        if (!log.is_valid()) return 1;
        log.info("Hello Homebrew!");
        log.force_flush();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lBqLog", "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"

    log_file = testpath.glob("log/test_*.logcompr").first
    assert_match "Hello Homebrew!", shell_output("#{bin}/BqLog_LogDecoder #{log_file}")
  end
end