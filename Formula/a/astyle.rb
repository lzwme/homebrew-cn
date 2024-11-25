class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.4.tar.bz2"
  sha256 "1e94b64f4f06461f9039d094aefe9d4b28c66d34916b27a456055e7d62d73702"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cccb7674c8008800cdabbdcd6e990905a93432751dcc82a0492b9b5939a34a90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f79644ed3bbb4b763d823825fee8c2d3554a6d178d76079cc0e7d5b905dd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3dca46c8dd7da60e3828e47676f25a8374117cfcf57c282e723fbf0b0095dfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "c60356dd8a090bc636c4a3dc44054b9547a98e2d81c0dc65b6caa6f1b849a0ed"
    sha256 cellar: :any_skip_relocation, ventura:       "5e0b3e8723e0473e8859802175ad38e9fff87aad91bf4c7a8b317ca6409affad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985990cffb3c37d2f5f280931026b95e16cc19696058d1eefd63d57506ac9e97"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end