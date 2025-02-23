class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https:github.comodygrdquill"
  url "https:github.comodygrdquillarchiverefstagsv8.2.0.tar.gz"
  sha256 "17381f3ff19af9b1fb4e8ba83f4f3c9e3e54c4aea58353282f4d3ac3e9002224"
  license "MIT"
  head "https:github.comodygrdquill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0c0a809893d92750380c290010334f514f466a08f81d0c84daf582f11af3064"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test", "-pthread"
    system ".test"
  end
end