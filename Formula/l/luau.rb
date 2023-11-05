class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.602.tar.gz"
  sha256 "c44cfc9cbb42a61135f881cce20a96be7f0d4413bc5800bf8b190abe6c7dd311"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb557e1039fe267de6c4206f5f7123eebf527c880eb5277e47a00119497b78ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8ee64223576cc81d716f75ce3dfbc5e38d402e00edeb9566ce91cd20275d3aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "155255312fcbc5993776ce4074b0ed066e1a594a9447353a135ec3a05f90edd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1f461f4f2ac937aa9cb57c591e1d48307078e5fdd3ac7b33289437201c6d048"
    sha256 cellar: :any_skip_relocation, ventura:        "b70c1732409ddf607e92fab5c3cc27a32d1e1d248711db02b6bde8e05715fd3b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd92a986af14060a2e029159f0dc06f939a59c16af5105d81350e9691e38516d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c2d90f5e32cc63dd5be2307ee99fb0374c795acea9851c37cbee4eb45840c3"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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