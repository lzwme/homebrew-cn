class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "bcee25589bb8052d9e155369f6759a05729a2022d2a8085c1aa4345108523077"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5ec488affdcc40b564a691636a7be9cb681984ef5327fbf2e837ed881cad0a92"
    sha256 cellar: :any,                 arm64_sequoia: "98f80dcf49429a56812105b152e88d30681adbb2e567e0d1131658ae2ff42c67"
    sha256 cellar: :any,                 arm64_sonoma:  "95cb0830bfa50cf10a9c97e98dbb079491cdd747fe8d186e9e30df8ffad3baee"
    sha256 cellar: :any,                 sonoma:        "c1f87d684b2f7f559b098fa27945037f13c06ebef53960d55218edae5a3e7780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34200c0f5a102c0761f0f97ffee2e4a9488435d5cfe52619e38dafb9977e4caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad12253e983a1bc33cc52225651fe3d1907959cd81dbfd083a31f08cbac555b"
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

    # Install whisper headers and libraries for opt paths
    include.install_symlink libexec.glob("include/whisper.h")
    lib.install_symlink libexec.glob("lib/libwhisper*")

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