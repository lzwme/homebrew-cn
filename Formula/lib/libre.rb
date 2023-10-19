class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghproxy.com/https://github.com/baresip/re/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "12a46474875ef39f1179aca0138939bd84bb9357f54341518022a203c110d879"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5bf637a7882285da95cbe0ecf49d3a64a3411ad832cb47386eca09643ac5972"
    sha256 cellar: :any,                 arm64_ventura:  "135dba4ab8f916fffdbb8098aa42a8adf210a81c1b190d6426526b9f5e7e9b8b"
    sha256 cellar: :any,                 arm64_monterey: "75203092327b1454ce24582db9415f2351ce6c3a6bd17fb0062b808344bafc77"
    sha256 cellar: :any,                 sonoma:         "cde567dc3e5266a082dfaaefcf3e542c73284a78a9c0e2c99b43e2fd26351ca5"
    sha256 cellar: :any,                 ventura:        "dfd7c930e410fcc317b5b670a8ecd6c144ed75dbdeb45eba382dfe58fdfa149f"
    sha256 cellar: :any,                 monterey:       "500c6c5111c8512690bc6cb60dbfb6a250bf76f2092e56f084322a751e519da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2255491f47b0d9be8d68e7bd700e49d4e452fdb342000aa5586e31e3d6f6420"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end