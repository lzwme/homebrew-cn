class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.627.tar.gz"
  sha256 "96a9cb1331663ec35fb7e868460d2f0895a2203fbf4f280525b1023d449b1da6"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2036fd675fd1a1865d5d3c70c103a05f3301b86de95222554f88ae7d7c143d03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9a94c74d06ac5ad39d17e74f34c798aa0824c5bf5950b6a4c62c60a7e0ccb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b02c3e811451ec14a6cface9442bfefe0586af3dacbc670beffc3968f119bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4901ccd24a2a09d3aa6073e1db2c99e18dfb179aaa0e73df06342c3288fd98a9"
    sha256 cellar: :any_skip_relocation, ventura:        "8b89b6af4ab77949dc76b3aa939be77c9cd2d3f3fdf72ea6ad174d86bb1c7652"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa3c80c5852fa7f5fe2ee4404e8cb5b4c50b5c8b3271c6f8df6a1c3452e2eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa27530c6bfbcf19684ffde40ed7902bcd0eecb399f77d994840f0896b261d0b"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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