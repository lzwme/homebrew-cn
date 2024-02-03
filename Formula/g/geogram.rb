class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https:brunolevy.github.iogeogram"
  url "https:github.comBrunoLevygeogramreleasesdownloadv1.8.7geogram_1.8.7.tar.gz"
  sha256 "98a58c5855f4ed0000a8054c755525ca4b8ed0bad88c4143ae3008ce75590ebb"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https:github.comBrunoLevygeogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4a1aa62102c9fc825c1bde262ab65a664c0ad598cff6de0d5850808f237a4de"
    sha256 cellar: :any,                 arm64_ventura:  "45d13f01959c09f3dd85e96cd20d5e710eb6f32d32a293ec7ff104efd2c09ab5"
    sha256 cellar: :any,                 arm64_monterey: "75292d7d729f23bc0d3c1c6354b954ae2517909cf08f2d180a76279fd21390ec"
    sha256 cellar: :any,                 sonoma:         "7f7d71a3707a56828d0687f603ab602aed9b7ba561cd01b6bfe245bf1bff546a"
    sha256 cellar: :any,                 ventura:        "fcf92e47e04d13486f9e361e818bf09be694ab368dd4b10d97be50473a49b2a6"
    sha256 cellar: :any,                 monterey:       "475b1096dcc539ab770994ea788da9a1f8d6a2b433c7a00df8f7065b1f2df98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "666493a10750a7039f4ad4d636bac2e5100ab02ede33fdeabacc535aa1d075be"
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
    system "#{bin}vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end