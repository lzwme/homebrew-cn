class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.7.1.tar.gz"
    sha256 "0afa508fbaaf4f76a4c39021fe4e6afc241baa00c245cc3fa4403d582d9d8e31"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "29c46809460184843c824d961aa380aa09f15afecb704d064296c57c30415867"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1be5da223ea40a997da1c9cb24baf73975e61886cc530306f2283e87c53f416c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "121e89bae6094382adbc8a7fc4bfc74dc35a8dfe2e90358ae4cf9dd81779656e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2757dd7567e7251301dab0a96f0843c463bc3eac9235bb4c5225cb7b058a8e7"
    sha256 cellar: :any_skip_relocation, ventura:        "471b1978feef67436f2511c26707baf4b19f842e4c9fce70b3d3b231387bb1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "227008fac6ee08e1f2c4cd5a84aab19e330067dea77241880c6b43ba9e685813"
    sha256 cellar: :any_skip_relocation, big_sur:        "c40d1611e58591ded55458066a7c62d939307685303d3842ce879a96206cfbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0838b7ce6f3574ccd0775aa98a8f1baf68fd175b1e835fab6565f04d462294a6"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end