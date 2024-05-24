class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https:chewing.im"
  url "https:github.comchewinglibchewingreleasesdownloadv0.8.2libchewing-0.8.2.tar.zst"
  sha256 "46a520295f5313067610a0fccec596323558fafa74245ea56fcf506c9757fbdf"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "57603da4fbb8bc54e12a38d7520dc1b64c7dc2a13972ccfab45679d1a8229ab7"
    sha256 cellar: :any,                 arm64_ventura:  "6ba9710f17f650c516123d5ae6bf8481ef3ff55826e754e6039a7ec33174ac54"
    sha256 cellar: :any,                 arm64_monterey: "cbc2cc38fc3383dc4e1715133639cdc79ee6dbc751cc9ebadf5b5ecb4a5ee711"
    sha256 cellar: :any,                 sonoma:         "4004a1c04b204b4d4cb25c1da42666762f8eca5513587324a62f482baf4d8760"
    sha256 cellar: :any,                 ventura:        "cd9ef6146afcb9a53f96654461cd95d1b9de1314c6a2236abbde7ad4ae0cdc5d"
    sha256 cellar: :any,                 monterey:       "f178dcfe3ac0bdec8da9de1463be4472d401f4b380930fee54f0fa72a236f91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34847129aa5c1d05b4f67301ad9914dd141d7ba4a53e7743b1014ba4abcfc5cb"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # patch to use system corrosion, upstream PR ref, https:github.comchewinglibchewingpull559
  patch do
    url "https:github.comchewinglibchewingcommit7ab350bd213c05389f14d1e97b88c019328977f4.patch?full_index=1"
    sha256 "5c9c830d4b67f06837a5958dfd5ba84ba7a3488e81c9a3c0d3906dad9bbcdcdc"
  end

  # add option to turn off tests, upstream PR ref, https:github.comchewinglibchewingpull560
  patch do
    url "https:github.comchewinglibchewingcommit31809bc57acbef19e3c051a104cac584a2bc22f2.patch?full_index=1"
    sha256 "13874606bad73beef47e045dadd82e150ed7503ddee5248997e772302bf78aec"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=OFF", *std_cmake_args
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