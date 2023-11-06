class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "1aca35d184c9eaa5785d2cef5c1411960659d92823c0accb3687d3829cf75cff"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "410702db7bccea1529e649c1319bb11e2227d7bc6d04dc7c8d58d34177736d7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91671ce93ea689fdbf3db883c2b39199f6594bcb2d92cf206a1789465117c635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395a4dfefe089244485d175011db22eb73059691ffb8fece9092ec8867608a2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc6818121771a8d207c3930aed3e62fb861f51073214a7949cb4d1f3f2d45694"
    sha256 cellar: :any_skip_relocation, ventura:        "d2aae9ca6634ec99c74c05f51397f0827ae46e140e889e31a10cd75c6c712b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "acd397f1a1fe1788daa8bdf5df1ce127f2c891e1926e1dd11a8d505a900cd33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd47662afe0ffc73e4508d312320b2ba5f627c02340db26c72e229ace9aafb2"
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
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();

        quill::FileHandlerConfig file_handler_cfg;
        file_handler_cfg.set_open_mode('w');

        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}/basic-log.txt", file_handler_cfg);
        quill::Logger* logger = quill::create_logger("logger_bar", std::move(file_handler));
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end