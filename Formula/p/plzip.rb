class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz"
  sha256 "50d71aad6fa154ad8c824279e86eade4bcf3bb4932d757d8f281ac09cfadae30"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "87bd7ffcf85a0d9cbf1ed155a5514e45867d84768ddaae9fad6bd4573f33a8b5"
    sha256 cellar: :any,                 arm64_sequoia: "8dfc51f42cbb49c2d4b2a845fa7c8e16d1336344494472dad00e9aea1c8ff445"
    sha256 cellar: :any,                 arm64_sonoma:  "c8de2539897f2006b34d24215dafcebec16f54533dc69c532eb3d6a42c2ef2d8"
    sha256 cellar: :any,                 sonoma:        "e97fc21b0ca62568f80f5271108b7df9e4c75b5a4684675c616648a385a52659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f889ea88d7b79ae7a9b23d8a81f7beee6758003716a8f7399d769c06aa971c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3199f435251873f53c8830e73bf813bcdbfc920cab72d6d6fa5170df4998e3e1"
  end

  depends_on "lzlib"

  on_sequoia :or_newer do
    depends_on "gcc"

    # Binaries created by Apple Clang 1700+ are broken
    fails_with :clang do
      cause "'make check' fails with '(stdin): Not enough memory'"
    end
  end

  fails_with :llvm_clang do
    cause "'make check' fails with '(stdin): Not enough memory'"
  end

  def install
    # Not an autotools configure script
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end