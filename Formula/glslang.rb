class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://ghproxy.com/https://github.com/KhronosGroup/glslang/archive/12.3.0.tar.gz"
  sha256 "45e0c7efad184206495aa1888c9008e168628fd1d3867a6975a7cd61dd11f53f"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebe4d05784642abdf22fd81de8f54210edf9e67fa8d372398b5aab5ec45c609c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5cae2984468ac16d2e20c713d43b23b777375d6fddfde2f5a5f836b13ca4ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fc340f1f2255082935d7c9be087db3ad73aee698aed735875dd6addddc0fbea"
    sha256 cellar: :any_skip_relocation, ventura:        "e9d9eab0ae84a66d8f088a5a7fab99b50fc40ea9c2ab8896b6a649e0de0d86bc"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf9e88c35e5ad39f5a5b936467a9eaba556f692f7a968bca482578139c18b61"
    sha256 cellar: :any_skip_relocation, big_sur:        "64bacd33a30378b6b4aa7f57995a76662bf51369bf1f6a7a0e536ab8bbb8a7d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a33a39f1408862cc356d3240dc6dba23151038e7d98ec4ae15d94153ea5c887"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXTERNAL=OFF", "-DENABLE_CTEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end