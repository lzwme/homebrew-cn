class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.686.tar.gz"
  sha256 "34dd6a83e71a02f684707b7041674779c03961858a8ecefdd74cad36afc31177"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d3a123e439e54d90d46aca83c223d65599a9a3d779b7eb6d7ece6248214d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce359193f13801e6f0182529a5b9c31695ffc8ca4d179aa280dd92603e20312d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "357ac7076d29e2f61c2928d3077a916a2a4cc180bb60de084604be6559be8c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f32a84775c7f0d66345230616b801183814c5866b9927cd2af638c27fa119b8"
    sha256 cellar: :any_skip_relocation, ventura:       "a9558484e5acb7b27b6e70c8c870ea23eed7ad5dba7703cf3801bf193b9808cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2096bb5d3efa6bf35e00e648d7ea36a4db187e42343ffc67da55b4e6c6f7ac15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576f1e6a3dd0e2f5db006bf23ed98026acf53bb26ff7c50616b9e7d31c847c47"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end