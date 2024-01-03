class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.85.0.tar.gz"
  sha256 "71056774e70ec1c173790a9979576e1142ef7d252271a1c12fa9d2e82a86eb38"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "264283eecf85b974111efaa1b451b566b2748aec72d93a75583c6dff2b58ddcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e4d6d545960f8a466fed1e2fc8711b90bf657404fa074ece5bdfd2bd04862c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b7e194233028899e1d3564196125676435474d9e2da7910252cd0d5c1c92669"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a1a7bfc001120d8b213b633b4b91561040cc99cfdc8f6ae62e873ad19efec2d"
    sha256 cellar: :any_skip_relocation, ventura:        "5932a43d4633b5a3ea08a8ae9f994999e0ccb2573e5aa3547450e8759e44dfa5"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e1f562d61998fffb58ef236167d49bf1529c2faaffc593114e6d4691c538ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f559212da17168bad97d95ced09b2f094ccecc34621acf225f1d4fd5fb476e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end