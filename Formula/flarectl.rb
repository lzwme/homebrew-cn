class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/v0.73.0.tar.gz"
  sha256 "21a507f43526f16b8bc1a2511f319454735160d4f7a9b05437465cbcd812bf9f"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba781ed0b1379bebd5d775ef265e4f143b05377f73b3b2e206a8aa91063def45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba781ed0b1379bebd5d775ef265e4f143b05377f73b3b2e206a8aa91063def45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba781ed0b1379bebd5d775ef265e4f143b05377f73b3b2e206a8aa91063def45"
    sha256 cellar: :any_skip_relocation, ventura:        "880342297ea4f78ff8f2b91e128837e8b5a61f2144fbcb2820f07f4528c76ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "880342297ea4f78ff8f2b91e128837e8b5a61f2144fbcb2820f07f4528c76ef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "880342297ea4f78ff8f2b91e128837e8b5a61f2144fbcb2820f07f4528c76ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6990bda51bf7f94b8e197f6cb00b8af06def933656f13b324e718f7a6e18d725"
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