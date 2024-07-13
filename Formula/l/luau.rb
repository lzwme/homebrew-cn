class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.634.tar.gz"
  sha256 "122c302f62edae41183287a16182db85703ada8ca489360da346686facac8915"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25220280b2c5e1b5a44ba70019b58e3ef691ebbcdde179dd653e0a37ba66e034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e3faa03d7713d4714e2ea05e11c53e1c02f0a799dc9151d98c1c17d52c6c224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70501fa06028ad78def0291778f6be9cfd3787e3da113799c52d5880b25e00d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3a60987553065fd6834cc7fbf6560289251ed14dfe25154f516e5e9cecfa7df"
    sha256 cellar: :any_skip_relocation, ventura:        "77bd1dc42d15ebd754c5544628ab7aee68053353852b2787de47bc35b3d899e7"
    sha256 cellar: :any_skip_relocation, monterey:       "79ca47a94c879e0d5cabca54cd01fe22bc3bbba857d5ea114a84802b90c95851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "074570506c8eb300d2699cf3ac18cb9ef314776389216c2fa45610add97cf8b4"
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