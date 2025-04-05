class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.668.tar.gz"
  sha256 "3f0cfeb48bd106f654377e6b07e82c9c5a5f642ce4fe29cb0078fd3b1eff1bf6"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "800ff3613c63100904ce1d89d91daa778cdc380d8f411048607b65ac05e65865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebde62cd40e06cc83a87cd92ac33cdcccdbf538adc8b0fab591229281f19dd90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "922f1ac0cc4a1cf3178d9861791e70d876e1bd7f078c3481cffb44cdac81de4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "413c19ab8c9c6ac706940c0f2e3e8041b6fe213435c2b79ad4528f2a2c99da51"
    sha256 cellar: :any_skip_relocation, ventura:       "e139667f86ed81beb4efed52d9399e4db4b557781774ba945d103e241e637624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f396368ff09dd70726839c66de9d0fcaf88d890b210cb7934a10779d3216cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f023e1a49cd9d7c0060ca91637d639b64f5239a7f832aec9ab0cb67e29a72f55"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end