class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.620.tar.gz"
  sha256 "a6ae1f0396334e72b1241dabb73aa123037613f3276bf2e71d0dc75568b1eb52"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "057baae836d61c722151bf82f232c74879d43729194b2c8b603241c5f9ab9d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4861c27e8ee8781b149e8ef437ca6e85d9c7fe9a71e1d7f545f2aeea3db41cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1010fe23d53153d16075a7bb531b41e9deed226df98f509c2cd3fceeb0853186"
    sha256 cellar: :any_skip_relocation, sonoma:         "297bdaa2501dc308ede12866bf7a8a53de7634d7d2777852bacb95cd59c77ebc"
    sha256 cellar: :any_skip_relocation, ventura:        "ec98524929254880e00fd615cc91b0617c93a0beeac495bd9ede108de3aa86c6"
    sha256 cellar: :any_skip_relocation, monterey:       "208bd8a6b7d42f12a3d8b81e00badf3d6785ff0db5eb1edae8db9a23fda59d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a73982e148ef5d77797c634ca6479dd765b50bf64bd95d5502bc65a7c18782b"
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