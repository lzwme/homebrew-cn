class Libaribcaption < Formula
  desc "Portable ARIB STD-B24 Caption Decoder/Renderer"
  homepage "https://github.com/xqq/libaribcaption"
  url "https://ghproxy.com/https://github.com/xqq/libaribcaption/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f7086598374d2f978d8bb1b675b082de2740a1792ed9c03838caa9ef58d7b51b"
  license "MIT"
  head "https://github.com/xqq/libaribcaption.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb8cf57a2f97e761174cbbc8680829521b118ff177fa7492125bb166cbcd013b"
    sha256 cellar: :any,                 arm64_ventura:  "7ddde82db3b18874c25d662d61441d40e70b57dc9ec10837ca10a288ae598855"
    sha256 cellar: :any,                 arm64_monterey: "8b17142360c7210639cc36bb33a21d44d8b23b61c1ec7f05852c807aaefe9a74"
    sha256 cellar: :any,                 sonoma:         "5ee566338537ebe8dd21130e039f75ab293fd0e21af37131eed4e9aa9d1ed0a8"
    sha256 cellar: :any,                 ventura:        "9584a0f004cfd9d81ed26ead29573426b15735ee623f8bde4feda6fb32ba3b43"
    sha256 cellar: :any,                 monterey:       "27073df385cdecb81f4c27177133f4ce76ca57fd0abdb3225e137cce3eb92674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae99927e8a35c453a98b9dfad48203c7fc68f4339095d42b5a411ab5b282778a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DARIBCC_SHARED_LIBRARY=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aribcaption/decoder.h>

      int main(int argc, char *argv[]) {
        aribcc_context_t* ctx = aribcc_context_alloc();
        if (!ctx)
          return 1;
        aribcc_context_free(ctx);
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libaribcaption").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end