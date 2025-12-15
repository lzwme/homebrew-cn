class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.6.0/apache-log4cxx-1.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.6.0/apache-log4cxx-1.6.0.tar.gz"
  sha256 "47d768c5765c5721cf27d520f87ef272291ba0f4e0d321c72735d5aec87018a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "012b1650df03535797b854dfbef70b47e2b76f8b3df644e97f1f9d718e0807e4"
    sha256 cellar: :any,                 arm64_sequoia: "53567377892f780abd2cc7e369ff8c9284d84b097087dae88e136633fd5d5fe3"
    sha256 cellar: :any,                 arm64_sonoma:  "4b45ae9c744b482a66d09118abb3256197f16f4ac25fe49179af6662c8b41d93"
    sha256 cellar: :any,                 sonoma:        "692a0cb8abd253c2d4cb57110e5c202655319b289b6cbc960ea90743cf80c506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5fcac484d92dfb137c89abcec421d2cec2a32981a186a71a77099c072df8c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6281d43870fae6aec068fa2db6b2be2423838c356f1280b6b77d68db3485b1c7"
  end

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <log4cxx/logger.h>
      #include <log4cxx/propertyconfigurator.h>
      int main() {
        log4cxx::PropertyConfigurator::configure("log4cxx.config");

        log4cxx::LoggerPtr log = log4cxx::Logger::getLogger("Test");
        log->setLevel(log4cxx::Level::getInfo());
        LOG4CXX_ERROR(log, "Foo");

        return 1;
      }
    CPP

    (testpath/"log4cxx.config").write <<~EOS
      log4j.rootLogger=debug, stdout, R

      log4j.appender.stdout=org.apache.log4j.ConsoleAppender
      log4j.appender.stdout.layout=org.apache.log4j.PatternLayout

      # Pattern to output the caller's file name and line number.
      log4j.appender.stdout.layout.ConversionPattern=%5p [%t] (%F:%L) - %m%n

      log4j.appender.R=org.apache.log4j.RollingFileAppender
      log4j.appender.R.File=example.log

      log4j.appender.R.MaxFileSize=100KB
      # Keep one backup file
      log4j.appender.R.MaxBackupIndex=1

      log4j.appender.R.layout=org.apache.log4j.PatternLayout
      log4j.appender.R.layout.ConversionPattern=%p %t %c - %m%n
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-llog4cxx"
    assert_match(/ERROR.*Foo/, shell_output("./test", 1))
  end
end