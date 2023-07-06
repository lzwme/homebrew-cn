class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/v0.72.0.tar.gz"
  sha256 "98e518bcfc959173b3d93fa98ba421662605e9c3f78271eae033e5a117232a48"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c4f0c492c34ea3d53e4421ffbe011816936b2112874a46a4841be5e7114f573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4f0c492c34ea3d53e4421ffbe011816936b2112874a46a4841be5e7114f573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c4f0c492c34ea3d53e4421ffbe011816936b2112874a46a4841be5e7114f573"
    sha256 cellar: :any_skip_relocation, ventura:        "aed5091a2c794b3b3f153933bdf5c2baed4eb2a72b22136f98addb47eaf17ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "aed5091a2c794b3b3f153933bdf5c2baed4eb2a72b22136f98addb47eaf17ec5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aed5091a2c794b3b3f153933bdf5c2baed4eb2a72b22136f98addb47eaf17ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb84d92b47a587900db3cb0102d44c75a032f21fcee231e7e02e78ef5e7c54c"
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