class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.19.tar.bz2"
  sha256 "ae5ef4ddf1f88288bcc8f6d53266707f80a81fcc6decf4da5fe5c8e420a0ab1c"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ffb4e5514bf73e563be7fac33694eb238c6de1302c2b568a2e845a133bf819f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2c3ef26799f4ac04fe63c76ceb8ba36b117e802bdb1ede9464d72602aec370c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f1b89315a12212346a40f451fc8b5197f3feebef2ae74361e8a2b0d267680b2"
    sha256 cellar: :any,                 arm64_linux:       "64403c229c581e0130dbddab1fa76d1dc56d46f4442b4afc0c6c380727a98918"
    sha256 cellar: :any,                 x86_64_linux:      "56059c93593149980b4b6bb22ba2c6387def6f20518f3ebf1b9187f1c45be040"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", testpath/"test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end