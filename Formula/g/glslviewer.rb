class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
    tag:      "3.5.1",
    revision: "8fa52d335b032debb64558d367262aa6ca4a99a8"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1cb1b657bf621d918c29a8d3ea66bad428dee9d3bf72a812094c1849893fc22"
    sha256 cellar: :any,                 arm64_sequoia: "47b8a1dafb040f647d44ed9b915bef3a713fc6b5e57c7323745cf22b153717fd"
    sha256 cellar: :any,                 arm64_sonoma:  "fabe5f1a8aa3cbb6e42736b1bf319c3ba0e73a118068da08b6171500f6e7110a"
    sha256 cellar: :any,                 sonoma:        "63b47203c06dc2af3d7154948cdff0ee64dabe9257459599af262fa5c1f67fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14364cfb5d206c048999a8915ba82c21e51ddeebdfcff8dfc61a499c4d75c9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9e5c1b355b6d9e0e8446bde68a96e9ca5128f969aff36d78afb80ac5a45ecc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "glfw"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/io/.", testpath
    pid = spawn bin/"glslViewer", "orca.frag", "-l"
    sleep 1
  ensure
    Process.kill("HUP", pid)
  end
end