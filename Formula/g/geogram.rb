class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https:github.comBrunoLevygeogramwiki"
  url "https:github.comBrunoLevygeogramreleasesdownloadv1.9.4geogram_1.9.4.tar.gz"
  sha256 "d0d54887e3c07cefc801de553a9d3bbddece43400c28d36ba031302a196c1c91"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https:github.comBrunoLevygeogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9ec4a1dcbc9c34930bcac08b4caa931bf7c118b7a21f8812bfb30e2aa8668b6"
    sha256 cellar: :any,                 arm64_sonoma:  "80293b283bfd042e8a063c7bd9c7754caac4cf2d3b160f40a1d9710740d6159f"
    sha256 cellar: :any,                 arm64_ventura: "c26302ea1ec636582f5cebec7c9672ac5a5add5c6ebd19d8c62141f994f5a3f4"
    sha256 cellar: :any,                 sonoma:        "5e2d3e32d05cfe4281fb00a9ca76ae409422f39782cab42be6cdb962b98db653"
    sha256 cellar: :any,                 ventura:       "7b796fe15499a5a9abfd476e54590345bd1dacc6853cc57b8a65e0665bc9f150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf3c4a262b8f5c7dfc6e14b21f4b4da86a0bcbf22d401ec9ff04b5869893e5e"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  def install
    (buildpath"CMakeOptions.txt").append_lines <<~EOS
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    EOS

    system ".configure.sh"
    platform = OS.mac? ? "Darwin-clang" : "Linux64-gcc"
    cd "build#{platform}-dynamic-Release" do
      system "make", "install"
    end

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