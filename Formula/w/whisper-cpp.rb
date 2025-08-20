class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://ghfast.top/https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "166140e9a6d8a36f787a2bd77f8f44dd64874f12dd8359ff7c1f4f9acb86202e"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a73cf5e83024ca4be20996941443aa93392da1fcbbc2ae55cdebac7bc4fa207d"
    sha256 cellar: :any,                 arm64_sonoma:  "f4f410f47e9e03b246402f2daad42be01edb540d2cabc39990779cb74a124baa"
    sha256 cellar: :any,                 arm64_ventura: "5336c0e2520fc446581b790f5a3564f0d8a444cd748d51463c188544909bee52"
    sha256 cellar: :any,                 sonoma:        "9bb84f02266e026d80315d1c0f8e722c044bde8a613ab3930c6f13aae2da0f2c"
    sha256 cellar: :any,                 ventura:       "367c853764388de25be607ab96f04e95f85fbfd10039f18314d004184fd4fa31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f816c8fdd222aa6bd436f3c600c6879dabecd1200eeacf2f06387321949491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46439542dcdc28917c98189f25be850036d7f8dab84895872f25fbe61752bd51"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath(target: prefix/"libinternal")}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]

    # avoid installing libggml libraries to "lib" since they would conflict with llama.cpp
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: "libinternal")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # avoid publishing header files since they will conflict with llama.cpp
    rm_r include

    # for backward compatibility with existing installs
    (bin/"whisper-cpp").write <<~SHELL
      #!/bin/bash
      here="${BASH_SOURCE[0]}"
      echo "${BASH_SOURCE[0]}: warning: whisper-cpp is deprecated. Use whisper-cli instead." >&2
      exec "$(dirname "$here")/whisper-cli" "$@"
    SHELL

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
  end
end