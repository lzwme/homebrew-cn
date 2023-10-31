class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://ghproxy.com/https://github.com/BrunoLevy/geogram/releases/download/v1.8.6/geogram_1.8.6.tar.gz"
  sha256 "5ea85ae4756a0f6028d33fbe44a71074c6549ad31be5e6750cc24456b7cd5331"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a61164e71280a44186deb3d45e596067da073aa2229e9cac5fc2205e9e2c90c"
    sha256 cellar: :any,                 arm64_ventura:  "4dab6ae7c3bd1f18f1ed76c36fb7754888f9d741e5a4608aebb9076a46f1cc8b"
    sha256 cellar: :any,                 arm64_monterey: "eb351449574235d856a60c72c1071ea7076cddb098fa2dde3b914f89e2a9a624"
    sha256 cellar: :any,                 sonoma:         "4432ae8fc3cf151d2d4e9f11cfd0aaa0d8c12ffc96fe8bda234ff40c70919ff0"
    sha256 cellar: :any,                 ventura:        "b5db384014c008d38f49ed9c4c7176abe9611635b65da7389563097fcfede244"
    sha256 cellar: :any,                 monterey:       "251115cfd6bd1f8905d0900f8cda03c7c2973cbdca427d83ab3d7271b7de672d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eeb443f6ef94c5247f551fa417574f24335eb4b63d59fd94583f9bdde57e094"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  def install
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    EOS

    system "./configure.sh"
    platform = OS.mac? ? "Darwin-clang" : "Linux64-gcc"
    cd "build/#{platform}-dynamic-Release" do
      system "make", "install"
    end

    (share/"cmake/Modules").install Dir[lib/"cmake/modules/*"]
  end

  test do
    resource "homebrew-bunny" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
      sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
    end

    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end