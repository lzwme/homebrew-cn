class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.638.tar.gz"
  sha256 "87ea29188f0d788e3b8649a063cda6b1e1804a648f425f4d0e65ec8449f2d171"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eb215d612514b438680adfa3be1172d47a0c8ebe58b954a49b29696189741a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42aa13b9ca032a34b98ec4226d6cb1dce5fd5289fce7b1c60a60eaf7755d2852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e53d5824814ce807b2abda159e4c899092753e906364348b8767c45164cff5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d26450b28fc81b82d723191929c1c2a4e1bd91e11cbd6d0ff68c0053ce4a59d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a0f5a400b2b1d1c0a8a74629693d4004dc008e191844383ca2ec01bbad22448"
    sha256 cellar: :any_skip_relocation, monterey:       "8627e3d0763cb62af0f1238095c5d1c8d5258d1db7e8c2901d196fae7b562224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40541a2a0fbd642dd2b1a17bd7a763ad0dee510fce1ea328e982107367a15470"
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