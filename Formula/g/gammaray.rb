class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://ghfast.top/https://github.com/KDAB/GammaRay/releases/download/v3.2.1/gammaray-3.2.1.tar.gz"
  sha256 "82d924fb858985f3d0227d065b81d2267af40f7158aca9bb4ac61305f5961ee6"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6d6e253e57dcd066f65be0a63ce4b324108f01df9ea015e8c9ad4668feda142a"
    sha256 cellar: :any,                 arm64_ventura: "8e8fc1c9dcde1a6ab1488bfcd036c84f2595663a8232f9746512036bb24ec74f"
    sha256 cellar: :any,                 sonoma:        "3061293d027b90102dd533a49e71edff6fb5a6a86779736cbbd2f40b486de177"
    sha256 cellar: :any,                 ventura:       "65e707f916d09297ffcd4480a1b2cbc3b43b81c3db338f20b04478dd57c30acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e62fc0d1c42295025ceb0c94bd47cf2b2926cb9275b5a8be88eab03059a0f2"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  on_linux do
    depends_on "elfutils"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    gammaray = OS.mac? ? prefix/"GammaRay.app/Contents/MacOS/gammaray" : bin/"gammaray"
    assert_predicate gammaray, :executable?
  end
end