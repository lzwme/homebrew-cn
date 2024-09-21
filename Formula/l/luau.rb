class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.644.tar.gz"
  sha256 "6180980eae4ce310c837e5339c352f72c73ea7b5574995415769813c681e4da0"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a05f28f249a1094be80eef7d57e16378b2c92d26d5842c5dd1490220991c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cb1911a690799ec15800dbe6220c21ac9545d8cf2a98ff1c351216f14c2157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3857e128e0e89a9cc1018c4c67bf361db550b8d3f69ee9eac8cbea146575b819"
    sha256 cellar: :any_skip_relocation, sonoma:        "38167bfc1b8ae013d7d4b9d1a91cf8cd92b496095a95d3f9e5b1a8e5d7638768"
    sha256 cellar: :any_skip_relocation, ventura:       "ed91e9fba75bc6bed7e9b5aa2cef3e7c87d31d1139dd807b480dcd85dee46094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba5631ced3017d463cd41e3959c1cb03ceeac81b2a869f6fc9277ad7f0b498e"
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