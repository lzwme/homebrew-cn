class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https:github.comHowardHinnantdate"
  url "https:github.comHowardHinnantdatearchiverefstagsv3.0.2.tar.gz"
  sha256 "0449667ea85c5b411c28d08a53f1e420c73416caa5b693c249dac9763eb97b7c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cbc9f8faf4b1aa63f83c34dc243113d2fe03d15c17bd97ceeb971c8411b56af"
    sha256 cellar: :any,                 arm64_sonoma:  "50f1f064486df8fd3b62b51da7095add418bbada3d13bbd450c77a684f1710ba"
    sha256 cellar: :any,                 arm64_ventura: "6e29b581ca350ed2bda42ef77355ecf860e42654b4f15d1e317e98103a9d7edf"
    sha256 cellar: :any,                 sonoma:        "4be73604956af8b374105368f9b2590e669b2e8fb5e8dbb9c4c187c8d1d37b40"
    sha256 cellar: :any,                 ventura:       "9cbdd741a129dc8d4f7d0bfcb496133d6ceed13e47a9070f651f266c5ff6b7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafb5ad2aa9a299288915f3f09914a36aff2ad187e9ce5a05e021616b8f01010"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DBUILD_TZ_LIB=ON"
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "datetz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ldate-tz", "-o", "test"
    system ".test"
  end
end