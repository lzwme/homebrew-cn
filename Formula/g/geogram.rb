class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https:github.comBrunoLevygeogramwiki"
  url "https:github.comBrunoLevygeogramreleasesdownloadv1.9.6geogram_1.9.6.tar.gz"
  sha256 "79dbe919737d8988668d6a72196a82389e0dfd8760250d26a28414afd558477f"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https:github.comBrunoLevygeogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22064d4eb5697da2062d89f7799331892e5a7ee884a6df8e17b73f714e33fd2d"
    sha256 cellar: :any,                 arm64_sonoma:  "2a964845fbba0b4b9d775ac636732b77d722d0b2ba57cf933fec5c0878e673d2"
    sha256 cellar: :any,                 arm64_ventura: "6409d086230bbc1d1ac4fbcfa5afb130361edfb67f99b39938924c70faad9003"
    sha256 cellar: :any,                 sonoma:        "68dfef9b699aa85f024e839c3b890df645890e55dbf5ab38d019e7581c57d4f0"
    sha256 cellar: :any,                 ventura:       "3ea71d80202019ee2ec11ca17074f65cb9aa07f892eea2125a5a8d8eae27895b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94b9da54d7c72b6c31208f3bd1516275108753a33398869c885a2af28aa6ec26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2d92bf98c570c42f3df59d39d2d1e42ba62554b1b993ccedf66e1dd39773a2"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  def install
    (buildpath"CMakeOptions.txt").append_lines <<~CMAKE
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    CMAKE

    platform = if OS.mac?
      "Darwin-clang-dynamic"
    elsif Hardware::CPU.intel?
      "Linux64-gcc-dynamic"
    else
      "Linux64-gcc-aarch64"
    end

    system ".configure.sh"
    system "make", "-C", "build#{platform}-Release", "install"

    (share"cmakeModules").install Dir[lib"cmakemodules*"]
  end

  test do
    resource "homebrew-bunny" do
      url "https:raw.githubusercontent.comFreeCADExamplesbe0b4f9Point_cloud_ExampleFilesPointCloud-Data_Stanford-Bunny.asc"
      sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
    end

    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system bin"vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_path_exists testpath"bunny.meshb", "bunny.meshb should exist!"
  end
end