class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.261.0.tar.gz"
  sha256 "09f779bcac08613cb13d14fd17eb3fc2ea165bca7eefb84a7c9dee6fb29ba492"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "608ca70b8bb9f177bbbcbdbe37a7cb785df94dae7a3dc86ba2142cbcee90910c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e14c8ee450a90dd5c73bc55a8c58b69195fa97d5304786d0a3c78d63feb301e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4342bcaba0c09c5bf225c25a859c3499cd01dc1ed06b39eaef6e1afb8a3b57f9"
    sha256 cellar: :any_skip_relocation, ventura:        "937ea7710a1148e89a19d2caf66aea66d38018e90513a356cc0030f0c6556ec6"
    sha256 cellar: :any_skip_relocation, monterey:       "77ee0662363ef849a19bc48826d33040ae64b9d03c413ca63699adba6bceae24"
    sha256 cellar: :any_skip_relocation, big_sur:        "23d7600cac4d1db86b49db8d989fc4044f8909d6d5988bb9f4d185743949e2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ca2f8ec5a301208aa3ad642ad3a3b7f96d15d7d88695791ef23c5e59f378815"
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