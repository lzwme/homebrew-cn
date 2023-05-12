class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.246.1.tar.gz"
  sha256 "44d1aef7e6e247b4b7ec6a1ef0bbb43cc9b681ee689393db90ac815d240808b1"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    :cannot_represent, # LicenseRef-KhronosFreeUse
  ]
  version_scheme 1

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "464ca952343a375232b504bc564283e62fb7364708d13f3ca8719a2aa64a4726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af4d05a115ef00947234c3f249c8b8d22588673b4105f708306dabaa418bb2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48c3a70065ca401678e99c6afb3fcf0c265916b80a859139f5fb6689607deb43"
    sha256 cellar: :any_skip_relocation, ventura:        "595f231fe6ef7810e90f3924b5de5702831fbc089d77dac3c9f025d7b6183d95"
    sha256 cellar: :any_skip_relocation, monterey:       "99becd1d5d151f20eb91ff10664040a1a9c842e6ea68a3fa0a6faf55c7689a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "994f0c216adc85566af9739eb8ae410a19baeaa610200a79248c70c6dac3c4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9811086eefe9341019a5e89145afab483c16a7739a3b8c6e2aa0f2f008c52b87"
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
    (Dir["*.comp"]).each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end