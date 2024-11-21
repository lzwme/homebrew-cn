class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https:brunolevy.github.iogeogram"
  url "https:github.comBrunoLevygeogramreleasesdownloadv1.9.1geogram_1.9.1.tar.gz"
  sha256 "bfd2e1051d1240cd3a9e58ca7390cff593d093af682bd2257ed8a43a4cf1eec0"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https:github.comBrunoLevygeogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7ec5fe4879b6a9e459e890287972555844bc906ee17aee2d31181ca41a2f193"
    sha256 cellar: :any,                 arm64_sonoma:  "3d477e5596833619228a8c86fc5d414e9e63d337e94d197eb4a4d8d38ac06e5d"
    sha256 cellar: :any,                 arm64_ventura: "8a712d73821e8d12a26a3f17e585741012a9226fcc4d283e3e4216cb03b8c0b3"
    sha256 cellar: :any,                 sonoma:        "452d197fc7c81096a3c65ed3f9574654e271414e5e2a3c4f30ec2ccdd4a9c0b4"
    sha256 cellar: :any,                 ventura:       "cac453e6b02388bc3ef805328f1dc07de30cb300f3e9cb5d2585ddb086b6bedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c976cc78c1db7b778a036ddd800669f2c48db2b6734d3286b0f69a6998f5f29"
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
    assert_predicate testpath"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end