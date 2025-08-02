class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.685.tar.gz"
  sha256 "5bd3e1f849c6ad0d0254a35372d1d3eefa3fdf9abc68d501489a2f653ed77560"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86618aaf7bccd6f4aa9432482c4a0b5d903b870d79101a4a5bef735361d0e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b5b2f2283482e160c563c436eda8aa364f14759520e9689783056d94b0b856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0cab6fa2d6b7341b1d4bcc019a94485e19cf05b40ca2a9daf3cfeff09ae543f"
    sha256 cellar: :any_skip_relocation, sonoma:        "41114b165aa7134490859e3fe722f5e066937e208f646d4c77346e9b9a751539"
    sha256 cellar: :any_skip_relocation, ventura:       "1e5761e576ee5cc3cc98f113eefc5f66096ef0b80d0342c45ea8e901825cb740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3297ca909a25fd58f4f559c5038e7b718a60b27a01d4c35f783be0043b83be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80225e1049a8661d714f3dcf56f4214bebed4ed0a9f7eb151d8c2e4647f79b1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end