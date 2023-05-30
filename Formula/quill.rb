class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "921e053118136f63cebb2ca1d7e42456fd0bf9626facb755884709092753c054"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7176c960c5f8577918c1920ab479a5c759eb29c17a033bb1127ba855086d3bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b9e13f03b394075f5955a048078c1b473027d5f755dbb95b4515ae703b3a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bd5b02696af5952ae353ac29ba7070f70d2ed9867d2e589d6c61d1a7983780d"
    sha256 cellar: :any_skip_relocation, ventura:        "c53e9b7fad840c095cd0e48aa61e2131a33bdf58729f1eae1ee40d18e78ea3ca"
    sha256 cellar: :any_skip_relocation, monterey:       "8dda3c66f5170790474af6f5bda1004b7f1f236c10308e386671b9f319b936f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b31ef1ed856c127bbdba98f54231dfd6c5dc05b0a4ade6aac81dd605675a65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8bfb6164fda1599829bddbf59cc71781c07467b63d973df60b6072d1a0c1c7c"
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
        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
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