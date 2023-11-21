class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "99f6497b8ba37c30c871fab89f14cd7bc989f3eaa921ccd940a521ee60a6a1c5"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e87bd36e85febe01118026507f3c72b954077dc3c446aba111022cfd80b52f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180fa3ef2dc907018fea02932f767a59b7e5db78a9cd4181fee5d303f6489bcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c7e27bee9e6536473a0b6a9a83349f45017e24e46946a2e539d9ec7a9b67b9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "68ce9dcf05b4d998fd873e7fba230705129ac196166144f7e97c8c49497b29ba"
    sha256 cellar: :any_skip_relocation, ventura:        "dc3d80d3ba85f21e2cffd6754177bae6c23175c34b8ddcd251532216c4a58b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "571e94cceef724649af9a11a9f5a4108fd3556a19a90d8783f8ae1ae802f4167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46f54a2edf31ce36d16d81b63452b60822bf917ebce9ce6cfdbec5541066129"
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