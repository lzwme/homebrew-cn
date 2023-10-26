class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.5/poco-1.12.5-all.tar.gz"
  sha256 "2e8f6d03e31cd67ca597f45a77daa797db3760035b445710a1cf4973863c2d0f"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aaa8968655ea183add0b1553e7182b2fb0d65a0e041ed3e72983543d4103a730"
    sha256 cellar: :any,                 arm64_ventura:  "fb61c043996963f726e97c85a4a3127a4d8859456a8317022ba454bd04a42402"
    sha256 cellar: :any,                 arm64_monterey: "9c6e57dc12def2c1b1e51299fd443337ef3c9a203f18d40a26325a13275655e9"
    sha256 cellar: :any,                 sonoma:         "acfbfb57d66c6b2d4e03e8c19bf1c521e5f96ef38d0342ab40d18997461f8119"
    sha256 cellar: :any,                 ventura:        "7e0be8c3ba454c8e061f87aff8d18817675ef586951b6a12c288af79e7910e31"
    sha256 cellar: :any,                 monterey:       "c08fabfd114c7b4f46f4cf6fbf849494981adac6179ae3f5b7cfcb28676746d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb267e0283362ee4771bd1660355b2efe09af18095f525e3947e877d85ba7774"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_DATA_MYSQL=OFF",
                    "-DENABLE_DATA_ODBC=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPOCO_UNBUNDLED=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end