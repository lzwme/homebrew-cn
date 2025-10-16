class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://ghfast.top/https://github.com/g-truc/glm/archive/refs/tags/1.0.2.tar.gz"
  sha256 "f972c5f02cd9fff4d76351268d5ea62518c8972e1e9de5d1dd4910261b50ef54"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a61ac3fc67b2eace8fec925731ae8452e1619d1ea8023be5bc9c9a22454ee3a1"
    sha256 cellar: :any,                 arm64_sequoia: "aea7cff938cf25ae861008d1e531f4fda9c970418e874c840f4581a37df40a8d"
    sha256 cellar: :any,                 arm64_sonoma:  "31421ae41806edae930012fa99361718421ec080090e39e2e818d88233742785"
    sha256 cellar: :any,                 sonoma:        "564c811efe5d541249603ad3f824f830f5aaa072e0417a436ada3e7439c7c354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63dd3d0f5999c81fb3bb63a61e7478a22ddbd2d23cd04f265a72e27815176250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57d8255fd7690fd00ee76f77ce7c462951938cda2a9ea4884f22ebf2c99bcee"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %w[
      -DGLM_BUILD_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install "glm"
    lib.install "cmake"
    (lib/"pkgconfig/glm.pc").write <<~EOS
      prefix=#{prefix}
      includedir=${prefix}/include

      Name: GLM
      Description: OpenGL Mathematics
      Version: #{version.to_s.match(/\d+\.\d+\.\d+/)}
      Cflags: -I${includedir}
    EOS

    cd "doc" do
      system "doxygen", "man.doxy"
      man.install "html"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end