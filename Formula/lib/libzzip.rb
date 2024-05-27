class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https:github.comgdraheimzziplib"
  url "https:github.comgdraheimzziplibarchiverefstagsv0.13.75.tar.gz"
  sha256 "1c167ab4cec1842d5b25bae1a9ce02ed671f23bc614c6c32edbe6d715097e65e"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0af67414f2187c31e2f193decb3b0e29cdefb8e953eb856a14230106fcb4004d"
    sha256 cellar: :any,                 arm64_ventura:  "6f95ce9e7b681beecd27396aa95655515ffe1acffdc441a30f1677aeed0e45e3"
    sha256 cellar: :any,                 arm64_monterey: "836c8b057cd2d8eaef70cc8dba471f6c0ca85b0059107fce3f2178e65e95e0d9"
    sha256 cellar: :any,                 sonoma:         "8f976bf7f7f8e3ee4a5d1a18b30619180a55482ac7edc5e2cebea4e22df8cca5"
    sha256 cellar: :any,                 ventura:        "af6888c1d7f7c8333211317426ab4f5ea4aec3df850d9fcf04e1eb977838e5e8"
    sha256 cellar: :any,                 monterey:       "28997377bd0a3c54c9025d874d0ad56a38bc0d0f3a12eb6e0b91d6ecc5cbfe11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22d05f30a92318e8621fb7b749bb6511980258b82c90ef4bad7e2f1e5346269"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    args = %W[
      -DZZIPTEST=OFF
      -DZZIPSDL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}zzcat testREADME.txt")
  end
end