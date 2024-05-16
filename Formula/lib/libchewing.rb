class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https:chewing.im"
  url "https:github.comchewinglibchewingreleasesdownloadv0.8.1libchewing-0.8.1.tar.zst"
  sha256 "038b7e1eef85f90b46c87fca7ca432796aaa14522291fa48c408c6f6f92ef83a"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29d657a6c6d2cb277591c75417a733a84657e766c9cee44812ab429b61f26ce2"
    sha256 cellar: :any,                 arm64_ventura:  "bdaa733fb0a811f15377a85aa82c0c512f0d09652d19fc19790d6d3ac4ea7bcb"
    sha256 cellar: :any,                 arm64_monterey: "45f693a90d651e1f4ed49d4687d66276e48b7523f2d4af5615ec13c47fbb7813"
    sha256 cellar: :any,                 sonoma:         "c08ad6a00b9d89ca045848793d95e4f8689ef09b65ba06d1e31564ef792c1721"
    sha256 cellar: :any,                 ventura:        "90d8c8be289fb0e0230dd39577299734b647c5b5f980988291a6305975007e1b"
    sha256 cellar: :any,                 monterey:       "73a3bbd40adbd843a1020c8748c9d763eb26b2af115a7133286ae736c2fc175c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaea9205854cc13f9f468e8d1d7e1c9af6247cf7ba04ab1286b292ff80a15077"
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