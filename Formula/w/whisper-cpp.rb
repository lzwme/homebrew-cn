class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in CC++"
  homepage "https:github.comggerganovwhisper.cpp"
  url "https:github.comggerganovwhisper.cpparchiverefstagsv1.7.4.tar.gz"
  sha256 "9ce7b33028793fcbf62f81f1fd087af7778dace8772eaba8c43c66bf0c8a3eed"
  license "MIT"
  head "https:github.comggerganovwhisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bb84f97ee62a11ea644c568932f22f245f6ba69a67ec3d183fd34c7efd1fe03"
    sha256 cellar: :any,                 arm64_sonoma:  "13a7ae04d18f0b64f729972efe20b62d388d27628ea4a4fa8745cefd36468a67"
    sha256 cellar: :any,                 arm64_ventura: "e5b4770c656277746cc7e3278b0d9434a34ae1413796646121c62624407d626b"
    sha256 cellar: :any,                 sonoma:        "6878e4918ccdd1c48b68d471692ea18e5f2e33c0cafe81d5a72c2fd4d2491757"
    sha256 cellar: :any,                 ventura:       "ef9b087cc14b4667f382a00d964723c651a6b75fc54b6811a28bacf6c349ae12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9eaf4be64f4147088aaf7ad53908dac2f8585dc7676b93c8914717896b416fc"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath(target: prefix"libinternal")}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    # avoid installing libggml libraries to "lib" since they would conflict with llama.cpp
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: "libinternal")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # avoid publishing header files since they will conflict with llama.cpp
    rm_r include

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