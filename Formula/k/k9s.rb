class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.31.7",
      revision: "ecb253622e86146265393a4411c17bc584d56ad5"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d069257d7da3a6277d76885f8e42c261d5463bbb672c0e4d429efd3b046dfb84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e950b1d93c9cc6edd9909eefc0d7c4347af923d12ebec1c016848f5a6bb397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f9334fecb36c781e899367cbe4173fa720982b8d605da59d7fab37fabf1e18"
    sha256 cellar: :any_skip_relocation, sonoma:         "76ff00c8602a9b8c5c5c9546bb90b8cae7bf8b5fb5e374a8a2ce4ff26a0b35b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d208a125e2c71d4bff5e792005faee0e77dc4fba8836ab91e08b7458f9a39abd"
    sha256 cellar: :any_skip_relocation, monterey:       "b6cd26e27837533d990a28b726c1406f55cc011ab40db92962d000d79db246b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d7bd41281411c51e4a5e6fc8b6ebff35c982d3a86d73a8ee19d0db40b23860"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end