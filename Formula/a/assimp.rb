class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://ghfast.top/https://github.com/assimp/assimp/archive/refs/tags/v6.0.4.tar.gz"
  sha256 "afa5487efdd285661afa842c85187cd8c541edad92e8d4aa85be4fca7476eccc"
  # NOTE: BSD-2-Clause is omitted as contrib/Open3DGC/o3dgcArithmeticCodec.c is not used
  license all_of: [
    "BSD-3-Clause",
    "CC-PDDC",   # code/AssetLib/Assjson/cencode.* (code from libb64)
    "MIT",       # code/AssetLib/M3D/m3d.h, contrib/{openddlparser,pugixml,rapidjson}
    "BSL-1.0",   # contrib/{clipper,utf8cpp}
    "Unlicense", # contrib/zip
    "Zlib",      # contrib/unzip
  ]
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fb93e11d0dbc91e5f60c420b1c9f1ddd83c0f41a5b9e4f3ec487e6d899314d8"
    sha256 cellar: :any,                 arm64_sequoia: "3b3010df5e86ee71ed540a702249bd592d7de657fbd9211cb218256616c10479"
    sha256 cellar: :any,                 arm64_sonoma:  "17f3e415cf49f3efa93f8fe69f17b260a3f22426ff92e96fd4c8395d5e4513c9"
    sha256 cellar: :any,                 sonoma:        "ec56e5465d0c69ce620d89ffd84c758b791efebcf2b5466ee59b1ccf6018886b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889fe27d780890620a6eab60cc3298ecc18642a138db9b47a8cc12663c7ff5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b4441a7429f787b6874ec574968e08a7328739dfb707881d1ccbc19630ab5f3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  def install
    # Ignore error on older GCC
    if ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 15
      ENV.append_to_cflags "-Wno-maybe-uninitialized"
    end

    args = %W[
      -DASSIMP_BUILD_TESTS=OFF
      -DASSIMP_BUILD_ASSIMP_TOOLS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", " -S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~CPP
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    CPP
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end