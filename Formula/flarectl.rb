class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/v0.71.0.tar.gz"
  sha256 "62e317770b17a6ae224cd9246ab3a648b0f63a2caedc0ee2d6173a6c72309b99"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f924e434595566127f7236387cb1f9b2c6bb434182917d250ea052cfe16a018e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f924e434595566127f7236387cb1f9b2c6bb434182917d250ea052cfe16a018e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f924e434595566127f7236387cb1f9b2c6bb434182917d250ea052cfe16a018e"
    sha256 cellar: :any_skip_relocation, ventura:        "035d52032b588b62981f682efd5219f26e70e15e352bf5b3456c1aca15039b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "035d52032b588b62981f682efd5219f26e70e15e352bf5b3456c1aca15039b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "035d52032b588b62981f682efd5219f26e70e15e352bf5b3456c1aca15039b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78084a32b7fdee867fee069745c8affd2adafc98d3c7682a4c5472d52130fb0"
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