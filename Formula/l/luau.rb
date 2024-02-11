class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.612.tar.gz"
  sha256 "b2a954873b21d5bc94266f7bb2224a943692bebaba654268ace15da8fbc70ae1"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c58479f150dd097d580dbf4a4f4f5a31053f4d358a811492e460965d51ac73ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfcc17e632f0e88c4ce93ecfcdd6d79cf56fc7a7fccef5bbc4807f8f88f410f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7914f7a85b43b9090fd001896f313f25a622251dc92ab9672550dbdd1f96a7cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce8efccf2a389d1a3763f552496adae5c1db5a6588405bf52f90e12483147e8f"
    sha256 cellar: :any_skip_relocation, ventura:        "3531be94ef0bcd12e9e26716e55bbcfe9574d8db689be207f0719679cd9defe5"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbea30275f9eeab032c07b084b23aaf8c64097a2c38a878f6ef7a4e843a1faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222f5323cde12c69e498f66393495cfd0eecf6b37c37449a67ddb10636b0f200"
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