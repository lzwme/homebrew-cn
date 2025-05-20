class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.3.2.tar.gz"
  sha256 "3be2e83b27cfbbf6692b215f9d4c1d1076b8e0adf7a2e0eabd2417601bbaaac3"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36dc04f7eba347be669c6159e9b99bf7c03bd5c62bc9b66cd2bc38dccaea6daf"
    sha256 cellar: :any,                 arm64_sonoma:  "04c90d9048f99501c87a184e64a779839b2ab337a8d99a78f0f56e78ebedd6d0"
    sha256 cellar: :any,                 arm64_ventura: "957aa02e229aecbe48ad224ec86a409d5e5986f907daca6702520bd3e30bfeeb"
    sha256 cellar: :any,                 sonoma:        "cd765f35ad55143577770139328c1f0660ed71cf1be81f13a89b2266b41f5c15"
    sha256 cellar: :any,                 ventura:       "b515c494021189ff5023d5c88d28c79645a7cefc2a86beea254fb0a4dbe15d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6002cb5e1ec57a7a2accdf8e091605e9f7a6fdbe01ef1209383d2ee0a4c31c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdfb6cf5645a3acdb5c5306da612877015bd5b24597cc8e75464ed6bd15e512a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <roaringroaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output(".test")
  end
end