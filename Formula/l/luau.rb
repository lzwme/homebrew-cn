class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.611.tar.gz"
  sha256 "67e928f50f3381e9345537538a8713042e211560a698bdccd086b041fde17699"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58def04afd14c5549c434ad72bc61ad40bd5d2f0beb35bdbb83d276f3a72971b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58d74b20bebf05afc1ebba33b45fad03395b3fbd5850848b40e7a9330069fad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "354fe0a1bce881a869000288bee2a2da7d36fa48b03adcc274efc70e0c59f70f"
    sha256 cellar: :any_skip_relocation, sonoma:         "006a626417ece0d0956746145d405cf141f4071899ec6ac620a9dcede446a028"
    sha256 cellar: :any_skip_relocation, ventura:        "dc12d08b951d529a9f7090b315cf049787f74edccdcbfb84fbc502d3a8b86b60"
    sha256 cellar: :any_skip_relocation, monterey:       "2adee4cffc6e83c72a6147a766d65779a364b9aae4a3579e32cfbf2a04370842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173f491f91610e976f7151898022f7ac5422202c9aa7c028e53baaba4699f7f2"
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