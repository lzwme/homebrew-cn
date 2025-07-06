class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://ghfast.top/https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "9bd761d55745250988b159ccc74f0e5898057e74cbddeb24447d870af52cf755"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "dfb803c2964b5881f94184238175c3baf2c5f908124278e36012c6ac5b8c1f9d"
    sha256 cellar: :any,                 arm64_ventura: "eb74f73ab2f4261f85c2db7c15e846268e0d8bf9fc6125b926ba3dcdadc606f1"
    sha256 cellar: :any,                 sonoma:        "75e47687518d5d00b50a85951ca772175ef1c7400b3245877d2afa292503fb5c"
    sha256 cellar: :any,                 ventura:       "5cd52df37218872d6b5d3a6f2871232c05aad0483773b1b3bfafbbf445c2f9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4e1a9b57c2bc7d13ed276123d8fa92f9cb4d3461eab6c0163a427abd463a0d"
  end

  depends_on "qt"

  uses_from_macos "llvm"

  def install
    system "qmake", "CONFIG+=release", "target.path=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test1.cpp").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello world" << std::endl;
        return 0;
      }
    CPP

    assert_match "Hello world", shell_output("#{bin}/cpi #{testpath}/test1.cpp")

    (testpath/"test2.cpp").write <<~CPP
      #include <iostream>
      #include <cmath>
      #include <cstdlib>
      int main(int argc, char *argv[])
      {
          if (argc != 2) return 0;

          std::cout << sqrt(atoi(argv[1])) << std::endl;
          return 0;
      }
      // CompileOptions: -lm
    CPP

    assert_match "1.41421", shell_output("#{bin}/cpi #{testpath}/test2.cpp 2")
  end
end