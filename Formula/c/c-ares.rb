class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://ghfast.top/https://github.com/c-ares/c-ares/releases/download/v1.34.7/c-ares-1.34.7.tar.gz"
  sha256 "556f781dd188ad932dc8263fee0ad3aaba675b4cd8e54d86908681b43ce3e327"
  license "MIT"
  compatibility_version 1
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9de9c5a3a303af0a89d4508b5c0eb07d30e8c084f003fcf89e777769c28c66db"
    sha256 cellar: :any, arm64_sequoia: "4f9370924b6868bcb8f840133d22e476bd7098a6d80c1913b469fb0999dfd070"
    sha256 cellar: :any, arm64_sonoma:  "c1525a2aea970f1f367a317fa412c2ba33d3c1634ccfea4901fcc7bb396982fc"
    sha256 cellar: :any, sonoma:        "bf5170e7d181149e2ca5fec4dacb590a27750af163b701f8d3a184ce7423e052"
    sha256 cellar: :any, arm64_linux:   "82f0cf8f8880f9d00b1988160eab469bebbe7d57826b9fc7d65946d1c8fde5eb"
    sha256 cellar: :any, x86_64_linux:  "fd7cff6647754ab3ff999bd60927958f0fd02067193c82f4c26191e37130ca3f"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end