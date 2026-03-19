class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "870ba21409cdf66697dc4db15ebdb13bc67037d76c7cc63756c81471d8f1731a"
  license "MIT"
  revision 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e0ea9ed7ccf601fea3c9420f5d858678a8545e3eb1699bf2496d6ad5f7b1f71"
    sha256 cellar: :any,                 arm64_sequoia: "fe0330ae5ff226162518de18d80dcb5e7975da15a07eadd7692a99026998aa8c"
    sha256 cellar: :any,                 arm64_sonoma:  "19c13da9b026f9cbea6a5b14a713de935df6c249e37127b296576517c851aba5"
    sha256 cellar: :any,                 sonoma:        "1924781a85172e26234e6c6ca7d941fbe09229487460e1c6d28e6ac1d1c4d665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e06990c957249aca97063639139c4ed9ca89f79d85aae5d3057b458642d26d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945ce43e2a54becffb4add413a2fd37edf61492324120ae051a498062761116a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "ggml"
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
      -DWHISPER_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "models/for-tests-ggml-tiny.bin", "samples/jfk.wav"
  end

  def caveats
    <<~EOS
      whisper-cpp requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https://huggingface.co/ggerganov/whisper.cpp/tree/main
        https://ggml.ggerganov.com/
    EOS
  end

  test do
    model = pkgshare/"for-tests-ggml-tiny.bin"
    output = shell_output("#{bin}/whisper-cli --model #{model} #{pkgshare}/jfk.wav 2>&1")
    assert_match "processing '#{pkgshare}/jfk.wav' (176000 samples, 11.0 sec)", output

    (testpath/"test.cpp").write <<~CPP
      #include <whisper.h>
      #include <cassert>
      int main() {
        ggml_backend_load_all();
        struct whisper_context_params cparams = whisper_context_default_params();
        struct whisper_context * ctx = whisper_init_from_file_with_params("#{model}", cparams);
        assert(ctx != nullptr);
        whisper_free(ctx);
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs ggml whisper").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end