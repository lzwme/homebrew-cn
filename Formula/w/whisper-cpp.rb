class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "0b988ba5053cfa720f6d399f3f21885b01c4222178be435ca2272d6872717554"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b2aff878cc628e73266055a6163d79c90c81b7002aa8ec0a172872cfeda39523"
    sha256 cellar: :any, arm64_sequoia: "4463dcf3faa1da8d26f69bbbf0f9713cffec50a46c19d953f0d12336b8cefc4d"
    sha256 cellar: :any, arm64_sonoma:  "5b28bf751e22c86ede05182452ea46ab439a2ee711979543b47571b520a3311c"
    sha256 cellar: :any, sonoma:        "a830666d07d2c0abf51f4778812c1e37cc72f918e722354fa560a7b89aec12cb"
    sha256 cellar: :any, arm64_linux:   "8fdb28e4801a04883a4b5e629c1b2d564a7beddf6f7b200b8f4dbcdd387ea264"
    sha256 cellar: :any, x86_64_linux:  "7a27ab69f4bf158ffe888af6978207761c04f8e2dc3d78207d9b183aedb68cdb"
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