class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://ghproxy.com/https://github.com/CastXML/CastXML/archive/v0.5.1.tar.gz"
  sha256 "a7b40b1530585672f9cf5d7a6b6dd29f20c06cd5edf34ef34c89a184a4d1a006"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "057c4ab8947ded01c09f7a4e5f06d0d2495c46e8378e72f95818ef131cf77c47"
    sha256 cellar: :any,                 arm64_monterey: "34889b9e8b79d22bd8610c27e9e041ce9b798558bca0fe19f17a52a0b90b7d93"
    sha256 cellar: :any,                 arm64_big_sur:  "a47fe4eca6599684eeedef864862c99e6b6287040551e6ac3c5b4afb3727570c"
    sha256 cellar: :any,                 ventura:        "e6959eadabdadb05d81e14f7a4fdf9fe6d1bcfe95191daca967bd31f7746e958"
    sha256 cellar: :any,                 monterey:       "eeb130876c000ebeb9747ca6c038f1aeb46461e832ec8aec1e02960a6d892696"
    sha256 cellar: :any,                 big_sur:        "c23d8f6e9513ce5023ec23e90631f9d399784df6a21653bd3f6e29d5029dfd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1a73cec631dc4089f80da7631198186bd7ebcf007acbd710ebc564c137af99"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end