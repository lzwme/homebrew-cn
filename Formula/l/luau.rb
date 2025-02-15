class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.661.tar.gz"
  sha256 "d55c99c8df926c600eb2cf654aa5c1c357e2715bee6b2b6cdaeb13fbc45f3f9e"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244b011d1a03fc6b117d00f43fb19f197cdd16ae717d125a01a6a012cd60e8d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2201b6d337261846488b585a08789bc96b51a50c1c0bd1a4fa751d9051120699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d50a600b83eaac433c64521878793780540a01663b7ab64071e7b8fd578d4b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "4546a380657e384ef0ba613ceb2e977e8f1cde9c549542ba7e2217b4695a65f6"
    sha256 cellar: :any_skip_relocation, ventura:       "19e689742c1ef821d9c1e7f13d95b1b78baa614b375318b22865f88a2dcacf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba39b65a139baf4d04f732cef6430850f888034763889c6563dae8ea32b34b3"
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