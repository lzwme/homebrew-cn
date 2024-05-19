class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https:github.comodygrdquill"
  url "https:github.comodygrdquillarchiverefstagsv3.9.0.tar.gz"
  sha256 "6e6a46dc6ae94e8321aca00d27dae754dcc51ee83fe60078f8f1f3eb7b3b227b"
  license "MIT"
  head "https:github.comodygrdquill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23af13bcc8dbc569e6ed9279bfc93a62a38a75d2d6539d3b56377f89a8c0a010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56162de590068dc57c97a5e325500d184daf059a55467fb46146fe5789c39e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07247794d38b54540c184106dc38e1a736d7f29d2b0f81fd333731647e690975"
    sha256 cellar: :any_skip_relocation, sonoma:         "969af5deaa4567696736ea2d8643ab2db09b4de39f25f279dfaeb71799f6f6e9"
    sha256 cellar: :any_skip_relocation, ventura:        "60b6481b14b7f0b970d8e4f33b4cbe4e1b13bd938bbf41bce1c4c05088505faa"
    sha256 cellar: :any_skip_relocation, monterey:       "29b3bba3e52546ec595147ce3df12153f4fcddd30a4ca70baf318b29d1a50a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecde1b71677c57597fa63f2f932d2a07ddefbfbfd544b4bedf8d3c48f4e1d895"
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