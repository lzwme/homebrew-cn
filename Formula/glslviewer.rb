class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.10.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa2379f7279b8e64880f7685f2a256e104e2fb2b8e57a47ee292cbf5ce475997"
    sha256 cellar: :any,                 arm64_monterey: "e7fa27cf2e7eeed7429268623e63548db57a1c27f44e37a2a30700adbd1f90b3"
    sha256 cellar: :any,                 arm64_big_sur:  "c0e1850b1180eab586d3140a64a5a7b75094cc2bae12dbf309656f13e968a737"
    sha256 cellar: :any,                 ventura:        "b4ab276e1948ddfa3983d228a337ae2fb65555f12645b72af3966e25bd029fde"
    sha256 cellar: :any,                 monterey:       "d8cb6038670c1a4c353a30af813b854f23c3b7e35fd0386862a19827d706fe3c"
    sha256 cellar: :any,                 big_sur:        "c5070b326126322ab37af402a9324dc85cf16c683b1e6316c4fe40a902fd6644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b25dff1066f4dd4682b48e7473089d2f710e97efb30460fbff3c1dc15edc7a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glfw"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/io/.", testpath
    pid = fork { exec "#{bin}/glslViewer", "orca.frag", "-l" }
  ensure
    Process.kill("HUP", pid)
  end
end