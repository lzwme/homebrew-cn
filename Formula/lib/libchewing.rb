class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https:chewing.im"
  url "https:github.comchewinglibchewingreleasesdownloadv0.8.5libchewing-0.8.5.tar.zst"
  sha256 "472881fc7df7f1bc90383937c504589d80d542b5f2c4c5c007017c13a21f534e"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ef7e71d5b7443cf3c7fc08bd33bf376f6cb54bf6af203069a83edcbffef5d95"
    sha256 cellar: :any,                 arm64_ventura:  "85b945e2ba6468408b69a15137ddc54eaf29b4a1682673b4eecf3acaf3c69448"
    sha256 cellar: :any,                 arm64_monterey: "b96e58c16950027d036241cc80ee4e2615c811df431aa366378f519bf478b31f"
    sha256 cellar: :any,                 sonoma:         "0b839bec70a2463b55443ae89b148df676a79f92ca24ee535aca0d5e9861d791"
    sha256 cellar: :any,                 ventura:        "7b2998fe365dfb04a93bd7dfe5aae92207f204dc12fd94cded6cd2447414a2bc"
    sha256 cellar: :any,                 monterey:       "8c195f94098a82571cf630a570d4ea86e461637cd3b8d8cd1b5d7d21a7edf8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e9cf90e8ccfcf31f2a02fe375e5e3d3b02540bcfb61d0f8b56128ae8c49faa"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # cmake build patch, https:github.comchewinglibchewingpull575
  # remove in 0.9.0 release
  patch do
    url "https:github.comchewinglibchewingcommitb21ff8f118e6138b795da4d37026712516a12676.patch?full_index=1"
    sha256 "13d64e23d42c0549117bc2f6239cd09da03d17d2f8015a81fb1a3307aeaf708f"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <chewingchewing.h>
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
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system ".test"
  end
end