class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.622.tar.gz"
  sha256 "86261ad13f35aea008b6968db04a494412906853b2e4e5d3ec22b2b9a168d50d"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e997d8e68b431d22940cdba7c8d15e08ecf67c187d0320a35e63dcab423ff34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9676b3a1c47b8ba60bae2f6277ab656311b41967f0f33a254ffe711e0cf52611"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e8181b0f891b72485405695d64d353de0cf2e7a22873cb1eeba9482041bc0f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a150842b8eec1e7045dcfeb7d427c97ea8a1e8d8cb4e3d0e9636214de328949a"
    sha256 cellar: :any_skip_relocation, ventura:        "a81d368abdda0b530f4791e6df55594ab49a67d8b6d54d53b27a19edd4931b59"
    sha256 cellar: :any_skip_relocation, monterey:       "235b9f8473d1e3aa2a749109e712066e90a2abd5d739824907b484213eb2dc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b9c2ad37a6147a26476a1a2e24bd4f1ec4b5f740ba383d16e853b3ec2e18d2"
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