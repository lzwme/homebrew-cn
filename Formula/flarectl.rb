class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/v0.66.0.tar.gz"
  sha256 "1180866ec9c1589cc0fd5a72db22d7460793bbd7afd0f5f67ee22e3ce2df0412"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f602f146278cc069067d7be13d9f1baa384e32d6848e39c8b777d49561359f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb092da4a0802b96606bc6414b67384059f3e3073e2158e02b8d7ecfba4cfe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32a473b9f7624c97cae0d16174a81d2c868669ff8b74f5160b8d5cf28f53bb74"
    sha256 cellar: :any_skip_relocation, ventura:        "ece5161d2ceff392f6d6405c0e22c04be93c9a9a3e14b0ed11ae2bc640d17f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "c5196909a20f94f66eb2190947445a4f0bda8402fdf052b2326caf787b05357a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac02eade3fccc9ed6324aa4cb3c2ae64523a204748e49d83d3de885f8bdd1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94519b6448108f985bad0ed091e4a363d59eb58398c31f87fd5c6838c0fa35b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end