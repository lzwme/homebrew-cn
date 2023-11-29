class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://ghproxy.com/https://github.com/odygrd/quill/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "47a69465cddeb05645745bed0b3099b49cb627464782f765ce9545723ff1fe84"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80f00f9a29ec0a9764a148f5b5afbd5953d29f8c506b5224f1bc23d27617bbf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afee6ef31c5097db6442e837a2c7216331a6bd046528e53fd6909dffefd62107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a421cfb7decfdbcc76bb080d33d4f565d23f3f0a3497de160c2f209b2b0a2a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b7e507ddad16505285fd96351c0d618c1f45f64fa65bfd80813bcb692487d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "0980cd08495bfd203884a328565e61dabbcdbe38c8f9a4c3ea56787d43e05c96"
    sha256 cellar: :any_skip_relocation, monterey:       "9af854ca1fdf311a3fa670cded4f73c08d7d4bbc64c8d8cef64d1a0ce5e076c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "742bce7fb12afa8f6d8ea2f54677dbcd1478866e7a563c29681acf32ee63bfba"
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