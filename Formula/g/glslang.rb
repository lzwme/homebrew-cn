class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https:www.khronos.orgopenglessdktoolsReference-Compiler"
  url "https:github.comKhronosGroupglslangarchiverefstags14.0.0.tar.gz"
  sha256 "80bbb916a23e94ea9cbfb1acb5d1a44a7e0c9613bcf5b5947c03f2273bdc92b0"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https:github.comKhronosGroupglslang.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "051f7043d6606c138972e09c68fa8efd95d3332eacd4fd793701c96cc08fcead"
    sha256 cellar: :any,                 arm64_ventura:  "fb6611b902aa69837928be3dc2bcc2582eeff0a8a415995cce25fde81a147294"
    sha256 cellar: :any,                 arm64_monterey: "b88d25a412d011649c177e089e10edab6a07ebba07a20061f4147637a880db92"
    sha256 cellar: :any,                 sonoma:         "318a47afbfefb181d1b02c0abadf7798101ec32c8baacf295a3163185a9eb355"
    sha256 cellar: :any,                 ventura:        "05ef399606934d09a71a9ce403b3697e1c21a500683afbfe361c19ad77215586"
    sha256 cellar: :any,                 monterey:       "d4b11296f4a357bcbdf3d6bac400c1fd96c64fc8b2d7ffdd18748a5f360bdf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58bc9386a239713fad7caaeb8d5fac411fe7282d9b0fae16c1424c03954db3bc"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXTERNAL=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_CTEST=OFF",
                    "-DENABLE_OPT=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
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