class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.106.0.tar.gz"
  sha256 "2d985edb4d3024e9ec0ce9b6027099ee83867c30fbfb82ed39b36e2fd17a7a52"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471eb1352cf8a530ff3f6fd47040712d26b67e8759afc9540b6131f1ea70d7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471eb1352cf8a530ff3f6fd47040712d26b67e8759afc9540b6131f1ea70d7c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "471eb1352cf8a530ff3f6fd47040712d26b67e8759afc9540b6131f1ea70d7c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7953bf5022bd2eca65c416da5a4046e9d58362454f4ec6daefcde723973aaedc"
    sha256 cellar: :any_skip_relocation, ventura:       "7953bf5022bd2eca65c416da5a4046e9d58362454f4ec6daefcde723973aaedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2839d15a0f7715dd99520da76fcdcc9b13fe4988c018badad1ed6533e0a5b01"
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