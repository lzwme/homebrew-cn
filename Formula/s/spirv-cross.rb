class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https:github.comKhronosGroupSPIRV-Cross"
  url "https:github.comKhronosGroupSPIRV-Crossarchiverefstagsvulkan-sdk-1.4.304.1.tar.gz"
  sha256 "bd3614abfc83a52760e667536c945b6e136ab013efca72918f222403da081cab"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    "MIT-Khronos-old",
  ]
  version_scheme 1
  head "https:github.comKhronosGroupSPIRV-Cross.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c09e921570c21f9d34ff782c2a5c203958897a0963363e7b58ad2195d5888c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24683268ca72de5814e9a122db22058f137967a7c4bf78c315e02dc4441b750f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d0e14a534aabe9618e4faef2a44e936da5a594a65c7578d438378f5cb01cfc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a44ef9edc6b634db26328b94ca92edb715cdc365b463fdff01deea15d8d656d"
    sha256 cellar: :any_skip_relocation, ventura:       "befb13c3a6ba0da979f3b9b4cb931096f7c16f9356d32e7ffa3aa5f495b065ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d7a7aba16b32ce6f15e4123dcee81df72659f0aedd83b8151f599d8dc40c71"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # required for tests
    prefix.install "samples"
    (include"spirv_cross").install Dir["includespirv_cross*"]
  end

  test do
    cp_r Dir[prefix"samplescpp*"], testpath

    inreplace "Makefile", "-I....include", "-I#{include}"
    inreplace "Makefile", "....spirv-cross", bin"spirv-cross"
    inreplace "Makefile", "glslangValidator", Formula["glslang"].bin"glslangValidator"

    # fix technically invalid shader code (#version should be first)
    # allows test to pass with newer glslangValidator
    before = <<~EOS
       Copyright 2016-2021 The Khronos Group Inc.
       SPDX-License-Identifier: Apache-2.0

      #version 310 es
    EOS

    after = <<~EOS
      #version 310 es
       Copyright 2016-2021 The Khronos Group Inc.
       SPDX-License-Identifier: Apache-2.0

    EOS

    (Dir["*.comp"]).each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end