class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://ghfast.top/https://github.com/chewing/libchewing/releases/download/v0.10.0/libchewing-0.10.0.tar.zst"
  sha256 "303eb86da31b83e67840a5bf79874cca00b06ce35f0e46fbd5e669f4b561ca21"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3dd2cc03f169c9b1f6c170bdb1c8b8356af0e85e1aa15f42608661aca7bec54"
    sha256 cellar: :any,                 arm64_sonoma:  "02be69c6807df1dec3e519d7c52a817dd989702bd6ff1fd21b67f0f47291c362"
    sha256 cellar: :any,                 arm64_ventura: "f07d426146f22208ee70b59b6c4ab9cb7131c813494457d076b0096279a2938f"
    sha256 cellar: :any,                 sonoma:        "61e3d2321fcfb58b19ed423d4c4eb4df5666cdbcf9a0275d8de54bdb330c0b6d"
    sha256 cellar: :any,                 ventura:       "71663d89ed41199ec6f10fda3fba918202ed5a10f9ee7afb4209eb0d5bf2f865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e897f0d5710d5bdea6fd5ceacdd6eba892b176a3f4c86b6359ec0fb04ca111a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49ca7fb80de7433de352082278dcd796163db4ee6e39ada5b933a68b3903474"
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