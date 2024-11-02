class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https:fna-xna.github.io"
  url "https:github.comFNA-XNAFAudioarchiverefstags24.11.tar.gz"
  sha256 "7aa5fdc762e1abbf4721e793de589eced46eef872ee2b9a03ab79ac81b64082c"
  license "Zlib"
  head "https:github.comFNA-XNAFAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be733be5ba13a13071685c9ff9f370a23f4d19e58350da9ac92bc6881642afa6"
    sha256 cellar: :any,                 arm64_sonoma:  "329f696f61ada91dbc90760297ceb5161bba0ed91b392e54683572955bc7564b"
    sha256 cellar: :any,                 arm64_ventura: "199d8456873c4f14b08ee8a0e41f42b56acfa0b40c48b80700a4ff93b1caaf51"
    sha256 cellar: :any,                 sonoma:        "0a5d5263d6a31b93b6ba01cfb7426595f4b1309bc6a3b44f26b9a460a7f6c8b7"
    sha256 cellar: :any,                 ventura:       "ce186968b663cd0100bca8b00d1e5f6e003883b60d70d65d4aaacf5bca95b900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca839abc855cc2aaf568b33ce865ab17331b70abea25cf5ae90b1b9aaedaf9c"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system ".test"
  end
end