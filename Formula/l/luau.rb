class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.729.tar.gz"
  sha256 "6c30c2a8195960803b929a0015771c14fe5bbdf5acdcfc8a459a31b25a365621"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c16f13bf492eddf8de54cc6d0cedce1ed2c0d76f29f4ce4e028c4c3f2f91cac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9e2e47d68878679bf63240612a7e7ab99831805d18fbc1bcbaa1b1413214f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a356138ec66984095b35434544092a63644c39d8cc9b7a12180c040947fea87"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f662a59da2b633ec8fa19e0193f3bb2e7a5432d3f8248cd4eadd2b2b5b9147"
    sha256 cellar: :any,                 arm64_linux:   "758b63846b656636f8a007fe3f69afdd736ceeb44f718f93becb54a1882e007c"
    sha256 cellar: :any,                 x86_64_linux:  "31df2fc2f13bd3c16fdbe07de20ab5d713472338f07ddfb0f38c9eca3139608e"
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