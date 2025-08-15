class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://ghfast.top/https://github.com/chewing/libchewing/releases/download/v0.10.2/libchewing-0.10.2.tar.zst"
  sha256 "f2c23a3bb8bc01a9a43eaa190c62ab0f00e7591e8f28bc97ce916e01e3779116"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c88f05b34bb347ccd4ba9876f94675195d43a3435e3ef26fd5593445d59cfbc"
    sha256 cellar: :any,                 arm64_sonoma:  "b2dde16b7c7770dace1c662e63146ba45401ea95b58498cd01c29e951a385b6d"
    sha256 cellar: :any,                 arm64_ventura: "d71a00adb2ef9dc331abd3e80ed3f1e0e1387ab00294dfe0b6f65e3cba679cbd"
    sha256 cellar: :any,                 sonoma:        "6a69932f948ae7293de9786d66e6138fe051fa4140656c38ab3f4dc130d8832c"
    sha256 cellar: :any,                 ventura:       "d9d649f40c502901abd6a286ca13bfc08c1a530cfd4b999cac64bc427521aa4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79582660e3c2f62a52882448eae639e1612882153a1483f572b451cac3b2115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a48c87918ba148ec2a9cead1383442d71d1d01773b49733f36bb70d725a318c"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdlib.h>
      #include <chewing/chewing.h>
      int main()
      {
          ChewingContext *ctx = chewing_new();
          chewing_handle_Default(ctx, 'x');
          chewing_handle_Default(ctx, 'm');
          chewing_handle_Default(ctx, '4');
          chewing_handle_Default(ctx, 't');
          chewing_handle_Default(ctx, '8');
          chewing_handle_Default(ctx, '6');
          chewing_handle_Enter(ctx);
          char *buf = chewing_commit_String(ctx);
          free(buf);
          chewing_delete(ctx);
          return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end