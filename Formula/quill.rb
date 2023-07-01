class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "9e7aa64c4f8101ed2b59d1cf3156b1c6bdd712ca89a2ec7aa7166905edc3e621"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f551b66b1ce34df332f3b17421b401e4f24449bec8fc58d1cafde293ac87e0a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53439889928d4c5ef08a0f01438bbbc50e900af43889c2e26cf95d1fb017e267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43edca515601f1d0973f2b215592138813ac5633475455f89d8bb1c0c65bf800"
    sha256 cellar: :any_skip_relocation, ventura:        "2308122bbe9bccb44783c333a44ddefa857299776624deebd490903dad421d97"
    sha256 cellar: :any_skip_relocation, monterey:       "18a3fcd80e1f7970ca3cafb793a749814db9960af3d9ca1c4da9b5e222415c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a31bf36c9b746321375604ee5e7aa2495e88d87eb5ae3ab93585d78fcde130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4faf20e4d47fc93fe0a1c9764208d4054bd3855144c534bf2ab5761987da7369"
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