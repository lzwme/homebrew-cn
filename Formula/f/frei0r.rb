class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "e5536fe659682a3d0e7d98b759174ad8bf3e79bdda78d919d503d8c3d7fd35a0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a704ab4dac3d6b9131f0dc07d5b7b24920cd66ecd04944bd5f1855d911cf9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0595e27076b86449411ea177aa1dff7fa16a0518a35417905d0c98ae6dab57f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a2a410e7278238b05203dab855b42eef28f1a508679a4d5680cafcd1f38b32"
    sha256 cellar: :any_skip_relocation, sonoma:        "73a4e0d594d0fc5457ce573314418daa0d4d8ba562de4bbc919fb4e253e598c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edad656a69181168df75cad299672ec9999f5a1965afd5c3a62b72704c341173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a37bae2fdcc58f1bcd3ca60fbba703090986435b8bbd09f3cb738a5d256f71"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end