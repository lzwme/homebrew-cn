class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.649.tar.gz"
  sha256 "a5bdce9052b7feb163b3488a7c9b4213353b846bb588e6d33ad9dbec41a02754"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5e452d30287a12e1ea6686490bdcfacbbbf27287c524fd0a6c550dd89ca154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d50bcd343fc44f563e0b84bfc7b2656f876756c86a9ff1beedc05d33ffe3720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3efd1c1426980c64ff24c10831bbd46e607d94f82e0636311ffb3be4fbedb455"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3bed8558d577aa232b3f2f19ec13744e08e6161566bfaa41b973bf89fd93bf"
    sha256 cellar: :any_skip_relocation, ventura:       "b1169bbdd363b4d60320bc15460ba27a9a804a89c6125a64d0d3c59cd38ff50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "605d7dc8c11beb3e336f674d5560770333f480d5f31e74741841331cd2f248a6"
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