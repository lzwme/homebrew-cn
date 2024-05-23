class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https:github.comodygrdquill"
  url "https:github.comodygrdquillarchiverefstagsv4.0.0.tar.gz"
  sha256 "c4e8a5a8f555a26baff1578fa37b9c6a968170a9bab64fcc913f6b90b91589dc"
  license "MIT"
  head "https:github.comodygrdquill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "922836006fd3b15cc607a29cd90d5ede45bd459bb62eca0b39af4039a9f1a2e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "922836006fd3b15cc607a29cd90d5ede45bd459bb62eca0b39af4039a9f1a2e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922836006fd3b15cc607a29cd90d5ede45bd459bb62eca0b39af4039a9f1a2e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "896d465a6f268558871aec5896030267562b0fe4673ebaf59fc539c78fbefcbf"
    sha256 cellar: :any_skip_relocation, ventura:        "896d465a6f268558871aec5896030267562b0fe4673ebaf59fc539c78fbefcbf"
    sha256 cellar: :any_skip_relocation, monterey:       "922836006fd3b15cc607a29cd90d5ede45bd459bb62eca0b39af4039a9f1a2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "922836006fd3b15cc607a29cd90d5ede45bd459bb62eca0b39af4039a9f1a2e2"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "quillBackend.h"
      #include "quillFrontend.h"
      #include "quillLogMacros.h"
      #include "quillLogger.h"
      #include "quillsinksConsoleSink.h"

      int main()
      {
         Start the backend thread
        quill::Backend::start();

         Frontend
        auto console_sink = quill::Frontend::create_or_get_sink<quill::ConsoleSink>("sink_id_1");
        quill::Logger* logger = quill::Frontend::create_or_get_logger("root", std::move(console_sink));

         Change the LogLevel to print everything
        logger->set_log_level(quill::LogLevel::TraceL3);

        LOG_INFO(logger, "Welcome to Quill!");
        LOG_ERROR(logger, "An error message. error code {}", 123);
        LOG_WARNING(logger, "A warning message.");
        LOG_CRITICAL(logger, "A critical error.");
        LOG_DEBUG(logger, "Debugging foo {}", 1234);
        LOG_TRACE_L1(logger, "{:>30}", "right aligned");
        LOG_TRACE_L2(logger, "Positional arguments are {1} {0} ", "too", "supported");
        LOG_TRACE_L3(logger, "Support for floats {:03.2f}", 1.23456);
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test", "-pthread"
    system ".test"
  end
end