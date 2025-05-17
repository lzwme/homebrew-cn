class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.674.tar.gz"
  sha256 "7198b12eaac56932051ede8d8decd64713d811b081456209f4c73030b34a0037"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1321a6ef350b6f7b45af56ca039b1a21779e7f2c7f5c0ef9e678dfe151ebef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c257b395684ed75a2b5ed82ab4fcda7b069b948a300a09edc8265626646d64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf8e483c56718b588b50723effc293f3d77e285228e6965c4aa5a1d49d4cdbf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "184146704a18499b11f782c0858415b7c2ecf40e478e4c3fa883ffd7c01ded3f"
    sha256 cellar: :any_skip_relocation, ventura:       "e1da040d31964a30cea3b0bb3645f5b1b90aa538eb99d043c2ff4a6b998fd645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3763330107927acf31e9d9b83c55cf99448dd69e52a5756f50c7904f52bdb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181ad061aa44b67de0b6de000ab5948eb892d97d1b435ea3fff6781cfb620d4a"
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