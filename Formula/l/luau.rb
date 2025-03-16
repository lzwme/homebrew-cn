class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.665.tar.gz"
  sha256 "18eaa819f892e9175ac6209fdbcb76f83f22e029f0faf09a4b9d6ff6e7818e8a"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb8a07d8cb19ad15b6a025501d199351286b6b23135d754689ab4b4c943c5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca6e8c1d225ab787ff5e563c561e71d759add6abeb5fb94d614e2f01b4aced3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0669eb96b1b31311f6aae03114402534ebcabbd5dcb016260e9130a35ab2d417"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c38ee209f84650d5853184811a1e5811cc76a4f21f494c55dc27a1d5f42d1d6"
    sha256 cellar: :any_skip_relocation, ventura:       "c324bd3730a88c3390ec7adda9be3e7336630c0f0eb3163dc6c9148687db9d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bd1a2188887880c658e86b871aee5a62c09c399d1fda4edf97453ada0b858b"
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