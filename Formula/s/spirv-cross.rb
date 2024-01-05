class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https:github.comKhronosGroupSPIRV-Cross"
  url "https:github.comKhronosGroupSPIRV-Crossarchiverefstagsvulkan-sdk-1.3.268.0.tar.gz"
  sha256 "dd656a51ba4c229c1a0bb220b7470723e8fd4b68abb7f2cf2ca4027df824f4a0"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    :cannot_represent, # LicenseRef-KhronosFreeUse
  ]
  version_scheme 1
  head "https:github.comKhronosGroupSPIRV-Cross.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c7f5a80e212ca5c00c8f2bee55715371fef4a51875f648b5ae66b9100443c8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "927483bfc8503ad1073c5d0d27cfcb198cbce3b501e98bcd72531460f384c1d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8cfb3cc6b8159405f4a1cece82c6af1208702233803b4698e528641c23fb14a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a12905ba7ec17397a9fa14281f58a6186d7411a095ad0dcadc9c11d24174622"
    sha256 cellar: :any_skip_relocation, ventura:        "ac4eb3f62cad73fe5ce3be80990503995d2e441a6867c7efd77a87b2c33b2e1b"
    sha256 cellar: :any_skip_relocation, monterey:       "d45c1b8b06ac1b832d08f9f791af292316a67ad88cb8585a06e51e832a922ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576a2dc3f105e8a25cead9bc2169a132cf6d82a3ad28da6eaf73c00cfa490674"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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