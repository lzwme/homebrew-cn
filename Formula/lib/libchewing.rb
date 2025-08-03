class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://ghfast.top/https://github.com/chewing/libchewing/releases/download/v0.10.1/libchewing-0.10.1.tar.zst"
  sha256 "4f2538affadd0c09738166d8a700853866811c4094fc256c05585f443e50b842"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a04b8f05fdd8082db0fd2c09b14bcb567d84df3d119ca90a1127414d50129db4"
    sha256 cellar: :any,                 arm64_sonoma:  "354d13ce4f51f1acac9895d2fe76b1ff797f5986051905103fb22da9ab09ced5"
    sha256 cellar: :any,                 arm64_ventura: "503463f2f08b1e7829b79f51ec1150fbdae4573af1859cb9a3b8dba0fce57bdd"
    sha256 cellar: :any,                 sonoma:        "43426b6a93c630e1fe99e129e21879e9a4b175fe41907e99ddd4680e26d9272c"
    sha256 cellar: :any,                 ventura:       "35fb467880854ddf1c60c79fe22edaf15a4c8c411d4d98325cdd5ff13a303506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "779c9e5d3baa1c5ae57c301b97f0683bffe087ac24704f3ea5a4feb08ea6a396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862d9d5071e91e11866727ff51d0dd7f30e9b8e97499fa406b2c735bc95a1c82"
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