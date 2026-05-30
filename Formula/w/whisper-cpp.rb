class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "cd702189cb5e608c8bc487f4b151db593c4455925b37cc06ef76b44861911db1"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6672c752c9aafd6ee9c19dcf3920b7d76e4585309dcdc4e71bf7aa26dd43612e"
    sha256 cellar: :any, arm64_sequoia: "f8cf25bbc77f4cc36e47cd5fc72ff4d6760b7d401b73d26d4e848d088ef1d361"
    sha256 cellar: :any, arm64_sonoma:  "6d722bde723a03ec956a51a2d5d328051a046d86f5336309924535f828c7034f"
    sha256 cellar: :any, sonoma:        "5c9ed3830a2e7981dea3f0f04ebed94cb09d05b77ffa0fb2824be2a3f1f5f035"
    sha256 cellar: :any, arm64_linux:   "81ae8a9cfed589929603162fe72b891dde53238b3ed5b5298a17aae4e43140ed"
    sha256 cellar: :any, x86_64_linux:  "aa8fbcedb807e57f7de47acce715a8d414d4b1a344ca841d027510c6218c02a9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
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