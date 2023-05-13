class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "dec64c0fbb4bfbafe28fdeeeefac10206285bf2be4a42ec5dfb7987ca4ccb372"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428d8e188ac0b2b749192daab82ac69f6652412734c62abfdc253c78ddbefd29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f03a7cc7e1d08458699842b3bea476ae397364cf4fb7a4a2b9bfc80ebf6bc0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "276db2335732a94cfdf4733815346f344842daa172aa53f7955f92d7ae1b6ffb"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cb7e3f0c1f20656adc584c0f056ad380d2deac2ebd57604625e8d95adfc39f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1be5ee1d5407cd38b1ac33b5d3bac5081031fc479709481f77224d443fc941"
    sha256 cellar: :any_skip_relocation, big_sur:        "613bc49823bea9a547aa61c40da6cfa4fe7d30693e3d68ebdf88a62de4bba491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9829da4692393e3e4bf5db53abe1cd9c8d2d83fb09c696393c507b34f44641ae"
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