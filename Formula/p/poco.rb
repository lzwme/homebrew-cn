class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.5p1/poco-1.12.5p1-all.tar.gz"
  sha256 "d7c17b30f4536066f11f89e8b3b1145161ca477470a5482c63cfadb68cdf3e25"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "570e099a906dad609312f163df81150931bb6f703723c8b20398d8a1b93c0285"
    sha256 cellar: :any,                 arm64_ventura:  "137f85664133b09bad2a4fc2db8dbc20a5686fe35242e4f730245202a0b6e15c"
    sha256 cellar: :any,                 arm64_monterey: "cb8940a3a9af137b49787d67b9f2eb3ad45668635c0818d18462ab6fba6c638c"
    sha256 cellar: :any,                 sonoma:         "e2f725ced4db7b1a997f0063366df2c0d6d143e0c3714fdbd29a1c044519fb2a"
    sha256 cellar: :any,                 ventura:        "5a4d0c265b6aca1053b7f18b26a32afb0f7cd853fc6eca1544c2850868bb861f"
    sha256 cellar: :any,                 monterey:       "3b4e515c16f305b723a7e239a7b18b2a7be99e510984766596b816f7a3e038cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a51e062fde554fb30f4ffc9a95931a8e41fafac972a045d82c7936f624ed9d7"
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