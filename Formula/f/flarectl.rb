class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "57321f652823d0e45e058f00525dd98a6f1016d8b09edd8322c7f16f75e33e6c"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f51ae14bf2508d977d44be471b9e460cd627a846ed05fe56d5ba34d573aa7370"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2828d25460607e4c767a9c4c1c479de15ec809dc42800bbf28ec86937ac67605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "582802578132c53d8083f87a9379e20400c8df526bea5c615889b3919a0f40e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d13430c25e8bcdc84ecb2d1ecd2d24183be2ed7a78e0046637a499afc1d0636e"
    sha256 cellar: :any_skip_relocation, ventura:        "adaa04bd0d81b727bd239cf867b583b958d0da4b103f56ab2bf42b935731faa9"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb6a98c801e6d11e893ff856a8e7dc198f7bb6ab33ec5b59648cf34ec3929d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1f95b933b84798a0832a611b19d0e43f36effea7ddda302804537997a0bcbc"
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