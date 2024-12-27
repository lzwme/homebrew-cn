class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in CC++"
  homepage "https:github.comggerganovwhisper.cpp"
  url "https:github.comggerganovwhisper.cpparchiverefstagsv1.7.3.tar.gz"
  sha256 "a36faa04885b45e4dd27751a37cb54300617717dbd3b7e5ec336f830e051a28c"
  license "MIT"
  head "https:github.comggerganovwhisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c74c377cc365a428fe7f9190751965d6fcb410c27560c6e0b1f110c5ec9ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f7b086d01e2f41f15b2e688997872e250d42477ba91d30c8897df1bb3d39a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78d9815c81e513f8abd8b1fe52e6832fb92149fbb96f930f11f5be50186b4793"
    sha256 cellar: :any_skip_relocation, sonoma:        "4592ba6d85b8126c1624d5ae219ffa0959f60479393aa2a1d02458f1fbebf9ab"
    sha256 cellar: :any_skip_relocation, ventura:       "9fda78a85467ddaed23109f0f2c97609e351d98c297f013576207d1d1b9a0c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed56a0ed458735806110430c37376808efd6c62d9efb4b7d2b6ea0e94bda268"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=#{build.head? ? "ON" : "OFF"}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?
    args << "-DCMAKE_INSTALL_RPATH=#{rpath(target: prefix"libinternal")}" if build.head?

    # avoid installing libggml libraries to "lib" since they would conflict with llama.cpp
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: "libinternal")
    if build.head?
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      # avoid publishing header files since they will conflict with llama.cpp
      rm_r include
    else
      # the "main" target is our whisper-cli binary
      system "cmake", "--build", "build", "--target", "main"
      bin.install "buildbinmain" => "whisper-cli"
    end

    # for backward compatibility with existing installs
    (bin"whisper-cpp").write <<~EOS
      #!binbash
      here="${BASH_SOURCE[0]}"
      echo "${BASH_SOURCE[0]}: warning: whisper-cpp is deprecated. Use whisper-cli instead." >&2
      exec "$(dirname "$here")whisper-cli" "$@"
    EOS
    (bin"whisper-cpp").chmod 0755

    pkgshare.install "modelsfor-tests-ggml-tiny.bin", "samplesjfk.wav"
  end

  def caveats
    <<~EOS
      whisper-cpp requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https:huggingface.coggerganovwhisper.cpptreemain
        https:ggml.ggerganov.com
    EOS
  end

  test do
    system bin"whisper-cpp", "-m", pkgshare"for-tests-ggml-tiny.bin", pkgshare"jfk.wav"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end