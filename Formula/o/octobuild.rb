class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https:github.comoctobuildoctobuild"
  url "https:github.comoctobuildoctobuildarchiverefstags1.5.0.tar.gz"
  sha256 "3c355aae72134861d9c060061ab4ebfbb6ba8a5a7981f577c567af2dfbdf9279"
  license "MIT"
  head "https:github.comoctobuildoctobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028a593ef0d0a6b24d69e931d19c9707232f315efab624d16b76f6e8e3939b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b8d2ee5678de7b1fe2c0234b029932984550214071f01399039bdc51127d92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01c591047ded7b0e8e021acdf3e91f28de954e93536f237217e8bb052c548df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d367ca23ab315160d9e4350409616db74be873f5e3abf716a1d083d9d6686d"
    sha256 cellar: :any_skip_relocation, ventura:       "e0e728e7200e0df2dfaa1cb25e4166d544760abe1dd2198376aa09b6fb44a8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f236d463ca1f779606681ef1933a3b96afa145ec1956f6cf9328c5cccf846a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end