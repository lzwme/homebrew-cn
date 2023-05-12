class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  license "MIT"
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.246.1.tar.gz"
    sha256 "71668e18ef7b318b06f8c466f46abad965b2646eaa322594cd015c2ac87133e6"

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
    sha256 cellar: :any_skip_relocation, all: "0a33a84db0a8b233c391490ab62f9d4fbc3908d66f7a7871681a549075e64243"
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