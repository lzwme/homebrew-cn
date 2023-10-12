class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://ghproxy.com/https://github.com/lipnitsk/libcue/archive/v2.3.0.tar.gz"
  sha256 "cc1b3a65c60bd88b77a1ddd1574042d83cf7cc32b85fe9481c99613359eb7cfe"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82934a84b7755323aef43356f8239523839e05e42005233046994d33376ef104"
    sha256 cellar: :any,                 arm64_ventura:  "a5037a18c0f6d957a866a5e897ed52b07121f5484a0dad00725566d17dc7ff8c"
    sha256 cellar: :any,                 arm64_monterey: "668a55590220069e7b7711d37ff033aa36102a27cacd715bfabd0699bd3c2a22"
    sha256 cellar: :any,                 sonoma:         "0f391c7328b30c5e10263e59f1f313f9d5898a47fec936530b233734bdda5e24"
    sha256 cellar: :any,                 ventura:        "924e97f8e5171a7bfa973ad1032983ed58f99c610c691a4bfddbaaeab8b2b358"
    sha256 cellar: :any,                 monterey:       "799c04b2053d44ef0be1bea0b458612e8bde94f2dd6bd1165acb558b09a46267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981c06a396357ab4014a50e803216c936cd5d6f3da3befa199a5e6926ad3b42a"
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
    (pkgshare/"tests").install Dir["t/*"]
  end

  test do
    cp_r (pkgshare/"tests").children, testpath
    Dir["*.c"].each do |f|
      system ENV.cc, f, "-o", "test", "-L#{lib}", "-lcue", "-I#{include}"
      system "./test"
      rm "test"
    end
  end
end