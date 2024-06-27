class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https:github.comgdraheimzziplib"
  url "https:github.comgdraheimzziplibarchiverefstagsv0.13.77.tar.gz"
  sha256 "50e166e6a879c2bd723e60e482a91ec793a7362fa2d9c5fe556fb0e025810477"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e15ef1c410977d744afa77ab826ddd6de188c16ded3ff91712b3cf84606f4dd"
    sha256 cellar: :any,                 arm64_ventura:  "7333db2f19438375bdf8b944b536073837656092ff6327beb123baa4e4590644"
    sha256 cellar: :any,                 arm64_monterey: "ca0251aef25c7acbc42c311b5cb5f5f7ae6640f757766051de82c70536e2dd35"
    sha256 cellar: :any,                 sonoma:         "06dc5fb4ef2e7dd925921a2fff0a1ac9dfc733d8c073b7d25e94deca5853f38a"
    sha256 cellar: :any,                 ventura:        "d4b57372da09eea95f1a5d2fa86d261ebfdcbe2c7d29686a309b44e5141ec3af"
    sha256 cellar: :any,                 monterey:       "f55c8a81717f1b9676b56990eda4fcefed7d6706d562332acbdcbe54464869a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df661b10d55b6b58a5e8e28a237665549cdf964cb08fe7925ffc29789e7141c9"
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