class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "b7c6b05635e5fda85cbcc5a012d29b3a4ca1cc22d9fa54d5b6c33e4ac271e5e0"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed053d90db828513775eefeaf31fe5855ce620f94691a79d8d007d90b1a01143"
    sha256 cellar: :any,                 arm64_sequoia: "90a3bddf19bc4bfadc34d64eb0634e5da6b8701b7b9e6b7044ee985ffdf75766"
    sha256 cellar: :any,                 arm64_sonoma:  "6de72ce54132faeac6872f2c2726c3ff7e4b33189f8dc72ea8afe86ecd00f2a4"
    sha256 cellar: :any,                 sonoma:        "b0f750a103028da2db978161f13b34ad3895ddeb62764a6f2ee47187ac042c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d96c112aef37b79c0b5419cbec48feb057085573ed583e27e43d0a9934bc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4876ac61cf894b10c790113481fc339989419198d27aabb89574663239980b30"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]

    # avoid installing into prefix as ggml libraries/headers would conflict with llama.cpp
    # TODO: change this once ggml has releases, https://github.com/ggml-org/ggml/issues/1333
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Expose executables and pkgconfig files
    bin.install_symlink libexec.glob("bin/*")
    (lib/"pkgconfig").install_symlink libexec.glob("lib/pkgconfig/*")

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

    flags = shell_output("pkgconf --cflags --libs whisper").chomp.split
    flags << "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end