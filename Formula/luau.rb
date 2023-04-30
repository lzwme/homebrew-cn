class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.574.tar.gz"
  sha256 "0d8b4333b713b8d81914275b475a2bd9cc0be23d90cac214a36360ede180e9db"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe248fea3ee4af12b3f62951904ce59917e6253588e8da4547deb1607221e264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb73539a800090cad73f868345120e3522c01c0098d64f2168733a3374f54da3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "292ad74d2b9baebb6ef7dc25637936190a241aadbde8b5da88c17c912375a091"
    sha256 cellar: :any_skip_relocation, ventura:        "c59ab5be01671e056d1941608de854b861053871b70858000c4630f227b88a20"
    sha256 cellar: :any_skip_relocation, monterey:       "acf698c40e254a0922ebb1c8fcdd6c4d4370fc06005647a01ec4b0f59ccfa883"
    sha256 cellar: :any_skip_relocation, big_sur:        "c659ca346b9518da321e2336c6274ee43d3b58a36a7bfcdda4c268c46745540e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f610e45a9fe53cf575ea67e0bfa7d897763f9d4c6dcab95b4b2019dd9d4c0faa"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end