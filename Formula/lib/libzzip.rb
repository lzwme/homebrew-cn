class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https:github.comgdraheimzziplib"
  url "https:github.comgdraheimzziplibarchiverefstagsv0.13.73.tar.gz"
  sha256 "2aa9d317f70060101064863e4e8fe698c32301e2d293d2b4964608cf2d5b2d8b"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd912a466e218965d423f2126a2f8c68916f100c24082ac83af5f3896158053f"
    sha256 cellar: :any,                 arm64_ventura:  "1f312cfe8ef90996eb31d6e8006fe4fb8f947329bfd26430a74ed4071cfd7f38"
    sha256 cellar: :any,                 arm64_monterey: "8c5ccd360d91fd071220cbaf30c63ab928bad069df93deb917ccaad8fe02265e"
    sha256 cellar: :any,                 sonoma:         "186a76379b3042088892430c55a589e8a4b6da7ca0d023c64f1a1b2f590acc80"
    sha256 cellar: :any,                 ventura:        "7852ef2b43191149da1eee392217facd933e0a154e740afb0ce049ff97590485"
    sha256 cellar: :any,                 monterey:       "fa1e2134630a6d997ba558a4e04de1ec9af22cb4337f9cda1b33a9d297ab97bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60b18752ac8c2ea5d49f89157711e95992265dc4fcb321f49d2ad53622393d1"
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