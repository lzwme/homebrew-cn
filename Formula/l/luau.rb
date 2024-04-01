class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.619.tar.gz"
  sha256 "1579a3ebf520147ac70020cbb3dc63e138da113086997c2ace8c34a1f1f9aac2"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f78bef928406f80df0827c01bcae60870a6c4584df46995134ce177642c73e3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1fbe473b21609468860f14b23004f38bd9cb6403ed4df94bbcdf582ee6bea27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063066dc38fc89c2d3dee231f604851467edff6c244e5232cb1d5513c4d55518"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc80c970700a9c3e518d6dc92c7b3745089d9ccd86a909a5597eea55ed85fa52"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7232efab1d3e604677c997fbff6afd35180dea1a3585c503b578fcbc56f2a5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4cfa19cdcd58d5efa8883332958fec4d120e457e541ab81a670b805b1ec62b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93bb0280954c4ce39bb99ffeffac16b1528196ede7cdeaea0b22f416b279066e"
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