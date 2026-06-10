class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "b44e7862574f130c35659ea84a5504c501d7ed0fe296b2d66d7167f080b9c0a2"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1f0978e8e4a1df2c12c5efddc7b166420ac6dbc83b8ba3464194eb17488b403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a8f6a0fe96b253c4444a188da546fa8af7374678e03716e37246b1cd7bd8b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf75259b06039d2fa813ae9e051f845f498e09a20a833f3cbeff012d9f73a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f1abd654a2e3d1f47f7e65fc2c99e6c33ca7c1bc6dde4b4bd99717d497aeb4a"
    sha256 cellar: :any,                 arm64_linux:   "3697ce6bc8e105266ae90716534e15ed8de1a20adc00c9fc90e9a064ce83c879"
    sha256 cellar: :any,                 x86_64_linux:  "dbd8eedfcb715a7715d87bf2dcfb390c990ac908f5bdb45764d788061a36275c"
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