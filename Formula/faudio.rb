class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://ghproxy.com/https://github.com/FNA-XNA/FAudio/archive/23.05.tar.gz"
  sha256 "1c9a3bcb33e3ccad75a11a48affdc7dc13752ce280f2a4c63213ca6ed7ea0e99"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d56216a26375ab4d1532f68ae8a86a3c93d27154a0b115680c3aee3da5f8461"
    sha256 cellar: :any,                 arm64_monterey: "0960f7e36ba3f7d374b49513e25123034e6cb063fbdc30848aa897d3a4377e58"
    sha256 cellar: :any,                 arm64_big_sur:  "fff34b8b802bd66acbbbeae8b9ff2e7c2300971560a500d07e3d6bca8a677dc2"
    sha256 cellar: :any,                 ventura:        "ab7c6e069070fb76c609f037c39fb82e2094fdf306d7c5f1f3ec7305b7755617"
    sha256 cellar: :any,                 monterey:       "c4341fe6ce443a2c225d8b3f9242636a28fd4ed81ba7785ccad0280d1273a72b"
    sha256 cellar: :any,                 big_sur:        "ac9ff95b4ccc44a5bdafce8b67b3814db1e885e6977e60f7960735f492d842e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3bdacd4538e6d34fcfbb2e40435bb99e82bea0363e2c92db8052e27d93c0675"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end