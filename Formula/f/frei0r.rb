class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "dec04785ab4dc5fb8167ed542647a976d38a3ff63efab1980e9baaeee100d682"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e0beb8b8e867c6f6c253ed3557728c6512a41b249ba48821d34fe4a9ea81fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac12cc1042dee57a73e584dee0c04d57fa53ce6f6eba2643ad03a6061d99bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b6e3542a369f31b1b3000794bd96569d077ce1743b74947b624370b801e6ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0375d26726a06d92593b583cd874369855af86eb19f07ddcd9cd72addbce3432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed8af5cc204dc5520beca0f93aa91dd6047a55ea31ee22f148ca680addc2fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4fb533a67cab0f45b3e1a29279ba1c080aa07ec3fdf207ab58be6bf92ed12d"
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