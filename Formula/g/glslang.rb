class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https:www.khronos.orgopenglessdktoolsReference-Compiler"
  url "https:github.comKhronosGroupglslangarchiverefstags13.1.1.tar.gz"
  sha256 "1c4d0a5a38c8aaf89a2d7e6093be734320599f5a6775b2726beeb05b0c054e66"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https:github.comKhronosGroupglslang.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82125054d400fbf989277d611522edd4b0224d6fee78205ce68bd5bfb5698b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaabfb5a0be3ed448bca92ec3509f2cc47b80627dd9e51fe880c11b66a7b0bb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0505de184924cf59d53065247082bd66c789f46894f651d3484609c1e78fc71f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd2decd9f89031c9835c871018504317204fcf902b4f803ec4054ee1bc8092d9"
    sha256 cellar: :any_skip_relocation, ventura:        "4f83040703624f75f7bfd627a6a01ea7e9574e8bd83cc3038db643bd38a12239"
    sha256 cellar: :any_skip_relocation, monterey:       "5886f7d5817a9281fe3758eb847abbd9f197913dfe347349c3a440c5125e71c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa5f6acef44ab05cbbb45e4913b4d92fffd4be6f553e35e3c7a22becb4d187e"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXTERNAL=OFF",
                    "-DENABLE_CTEST=OFF",
                    "-DENABLE_OPT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}glslangValidator", "-i", testpath"test.vert", testpath"test.frag"
  end
end