class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https:github.comodygrdquill"
  url "https:github.comodygrdquillarchiverefstagsv3.5.1.tar.gz"
  sha256 "9fa4ebe594c66ce2a409630c304724fa7a2ada0d842ba9c9aaf05f0a90b461f9"
  license "MIT"
  head "https:github.comodygrdquill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dec7312129d03d8366d50f8489ee143ff4de23aae77d4e194b02cae35082540"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ab5309777b4eca7890a12c525b67f023ec85d19895f6535cc07e7dde7a3258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82ea6a77870bce924a38a73652714f5137786b9ee4f26d0cf290ff1d2acbde8"
    sha256 cellar: :any_skip_relocation, sonoma:         "90860632b0030b14edbb5d670cbd5214c7d32d268c00202081b721298c68b395"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa8ff5089fda0b5b0a913b6c44e98bb5120f4f5ce03c7011382765f0f29e402"
    sha256 cellar: :any_skip_relocation, monterey:       "51def0795cf14dd596bdb0996843af091dcbf8151fc58b0b84174bc75ff6ca94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928163445e23ede290d8bdc13735a90d0d42e7e7b83122a2e0a15963d9151408"
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
      #include "quillQuill.h"
      int main()
      {
        quill::start();

        quill::FileHandlerConfig file_handler_cfg;
        file_handler_cfg.set_open_mode('w');

        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}basic-log.txt", file_handler_cfg);
        quill::Logger* logger = quill::create_logger("logger_bar", std::move(file_handler));
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system ".test"
    assert_predicate testpath"basic-log.txt", :exist?
    assert_match "Test", (testpath"basic-log.txt").read
  end
end