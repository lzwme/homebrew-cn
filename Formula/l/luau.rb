class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.653.tar.gz"
  sha256 "52e3a690e2a0074830b0ff828d442aa6286299a77c738703c27f20573ee6c65f"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62249895f918d7e287268817e9a878a7fb338080a30b2c580f81a296f04d5d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4132b02b8c54093418ccd8735dd98e6b838ea8c8f1037a553f5076d37eadda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20b1df56cba80e093bfba95363e9d86961522a65cbb9fd52ff2b75820838be31"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e906e05dbd8f46b105faf75ebc6b718c22d28cdccfcda70b4508447d68b92a4"
    sha256 cellar: :any_skip_relocation, ventura:       "f0a88dc6c0b1a473394dabb001110baf0c62b99a528c0f34f28105e3adbc5bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2eba93f84b058e5cfa8a66e86d91867337086f92c23956a1c971462bc905f2"
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