class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "9e6a072909985c2b8a82d39105ad9cb211e0dcc31d19ba71ce5839f2589d4f28"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    "MIT-Khronos-old",
  ]
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a540ddf3762a19748d3cb8bfc9bfb02365858dbde5b23ba3642820f2b56a98f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d343751184a727becafdae0f992827a76dbe5999887d5adbea54b809789d838e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4953cef9774c939de312c0125f3161aa44257c9db5b1d6070bd63d1bde796207"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa0f0b82aa6545234ccc73652af368272b3480108bba6e3086fbd64e36c6f776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c1f048ec200e0e194e338c4a2a79691c3157ae2b7d56fc6dc8e3e4ce2e3d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b4b47817ce785321e5152543fbc367ff742b35dd54f112005f6e3ec6917ba5a"
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
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath

    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", bin/"spirv-cross"
    inreplace "Makefile", "glslangValidator", Formula["glslang"].bin/"glslangValidator"

    # fix technically invalid shader code (#version should be first)
    # allows test to pass with newer glslangValidator
    before = <<~EOS
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

      #version 310 es
    EOS

    after = <<~EOS
      #version 310 es
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

    EOS

    Dir["*.comp"].each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end