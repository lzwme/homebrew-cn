class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://ghfast.top/https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.08.tar.gz"
  sha256 "af769d927d61e27074d3deff5af7a3cb0573054e163fbdace51d531d09a000a8"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3a8552fc5e7bd612ac6650327e0c1b392984abe36d27ba5a98a4c0b16779891"
    sha256 cellar: :any,                 arm64_sonoma:  "f55663abc70da12b4cc9a12bbf4a5edfd9a22462479e86a83eb233d6845b3b76"
    sha256 cellar: :any,                 arm64_ventura: "dce7bcc294a550e090a388be6359fc34db0f7983504fb8c33a15e8c2006e252b"
    sha256 cellar: :any,                 sonoma:        "f60176af0ee547c011fd9dd813bb7056faa0339da3981ff9afc94908e0cea125"
    sha256 cellar: :any,                 ventura:       "41d667cfa4d56a5ba1e67b93683fea798df8dbf5f8268a82249549fc281dd4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb949a5359198f336ff8d9540a9febe5baa2957636ac3461746f603c8ea8697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7dc40ccf93a519b29bab830352b0da688f0c6fb2a9cb9ac69114e8cd6d11b52"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end