class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "9745ad83b285bbd0481bd14c1b866b7e6121a981dd211b914f5d55955040fd00"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0923130f4ff187584740a3787e4928b2b70502ff2f073f6ff708ee43a0f7a62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333060e23de79c0c09b94c1be09d4940264b6ba94fcbe33cde13a0a7f9d62716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d0b8a82a328a1b1db49b968eac2d675d5c9538b2fb0442aa7869da4da8d52c1"
    sha256 cellar: :any_skip_relocation, ventura:        "733eeca1c17fc25396442fbc4fb66be229749732ed1d2cbcf076864a6561ebd1"
    sha256 cellar: :any_skip_relocation, monterey:       "0b69acaeb7337ae8c4e6f562e6fb81ba577eb2f0a62edca17a87cd9f82785cfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2422b926fed9e103fd95a2a2defd2f4cd0ab1055bae98780188db312c16c3249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b692f2921ab9d74d995d4ab9130201538137bd2bee32edf3ab2f216ff3b8bf66"
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