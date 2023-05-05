class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  license "MIT"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.243.0.tar.gz"
    sha256 "16927b1868e7891377d059cd549484e4158912439cf77451ae7e01e2a3bcd28b"

    # remove upon next release; adds SPV_EXT_shader_tile_image
    patch do
      url "https://github.com/KhronosGroup/SPIRV-Headers/commit/d218c4ab72500ed8be5809ab2a03ff348a85e349.patch?full_index=1"
      sha256 "a8fc93bcaae4eea3b03c18e9c031361b228ecff6aa8c0a55d5ccb0839d51259f"
    end

    # remove upon next release; adds SPV_KHR_ray_tracing_position_fetch
    patch do
      url "https://github.com/KhronosGroup/SPIRV-Headers/commit/131fddea36482695f04bfa47df5fdcb9fa15a246.patch?full_index=1"
      sha256 "531bab56a97ce5cb2202d6cfa4fc4b9ab78bde899bd94cb4c6ae2ec2735c581f"
    end
  end

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23edca916bea4003a659427ac0e6da1f1ee238663c44fde7205b8f7ddd24bb3f"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    system "cmake", "-S", pkgshare/"example", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end