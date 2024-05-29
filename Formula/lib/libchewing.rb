class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https:chewing.im"
  url "https:github.comchewinglibchewingreleasesdownloadv0.8.3libchewing-0.8.3.tar.zst"
  sha256 "6c8734eb3e5bbb7e9ba407d1315ffdaa8770e4c21fca835fb045329ef7fd3a1c"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2dc3ecc2bed611df306ce6ca74922d631d9e832b036663ed0d802f512dd319ed"
    sha256 cellar: :any,                 arm64_ventura:  "3016e913c1fd5f87bc1e1b60955f58b96305e0e11243edf577e52a1e4bdf3a26"
    sha256 cellar: :any,                 arm64_monterey: "c10a1c9a3245c157d8098867d0b0efc40d8778df9db3c69fb5a6bbe4d7065a76"
    sha256 cellar: :any,                 sonoma:         "611bbc2315e7228a2deef89cc161a2d99ed826960b185865f7277b766152aa70"
    sha256 cellar: :any,                 ventura:        "2e04b74f0ee6d81f56797d99fbe18b0771686d17d9709174760c6c2bf65c7616"
    sha256 cellar: :any,                 monterey:       "8912cfbde607c76d60f58547f18217a5eaaef780f76208a369aabd23354bfb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47bcdc7cf36ccec22f25d3f2074e5876e666408bc7029e5d25ed28ded350550"
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
  # cmake build patch, https:github.comchewinglibchewingpull576
  # remove in 0.8.4 release
  patch do
    url "https:github.comchewinglibchewingcommit633977ad822deab43d5563112638d701a6bc9279.patch?full_index=1"
    sha256 "be099a6e70839b7f1fdc49b24ab618a149890dbfc4a4bff9543ae4ce12a7b818"
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