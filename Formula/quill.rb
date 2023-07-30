class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "2bf6a870960e002b2fbf322d0b1c6b547af92858454fa96adfc374d545c66a36"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aedf67d074cc6ea3dd11dea5db56535710f88c92b07a9d9b92bc85f76acae94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804b6d65c409da375560e3c7be73223d4f4a9d282b750eb7d26458e80f285215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d959f3fc9d1b924d4034dfc77e304f77dd55f9e24671661d43489778805bf1f"
    sha256 cellar: :any_skip_relocation, ventura:        "20b6d9be871b9a121ae310e0f683687389f9d40ec7ee1b2e48d9ebfb60fa7c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "b65b0641076b4d75e166ba15dc934689f822fe2cafc09dfcf79a0776ee0f423b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee1dc75843562b058e94540b03eca85acc59885c3533b169a5446e54f09ddf87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c597fec568781f52f0c207ac790726744d60cb548c0b61ed59b5518ea93d9a0"
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