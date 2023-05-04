class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.7.2.tar.gz"
    sha256 "d75cbb25f1ded7d5122cdd65a516849aaac839b70f22b645f3eaba7097ce7758"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "29c46809460184843c824d961aa380aa09f15afecb704d064296c57c30415867"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6bbb4962d20066a72b384fd05935c86a769edca05a6162a135d6bc0b668d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5420ebd71c60284406f43224efeaed0689f7af576e69ff6b2a2b70a1c2f31d19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36196b704e861a3d564c508e798a15c639a331a0938a1af85b0ae00be7b447a3"
    sha256 cellar: :any_skip_relocation, ventura:        "2b98d01f313e662363f99b02d8515ded6d89000d82aadd30271904107a771d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "eb1098f043816d3a136fc404f1e12429e4044fdcc20d66ef504a456ad8f25a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce4f6d14d6184a976da5e3859f79c5cbe401fecb4fed9748df68116637470ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb4a028ba94293a6e7272fe878ee0f57605a6db2b00eaeae8aa96b4e30228f9"
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