class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "26906893f46a75d1cb553eb8869834aed15f19762ae56187970a213010e988a5"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "29c46809460184843c824d961aa380aa09f15afecb704d064296c57c30415867"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7988e70914da1992dd9459302abcd48e92809d923014ca6288e4a95cf5b5e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83797783462be32b51d2dbbaa0659f943030375e012543adba0fbb9edf13e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "244533458ba847a5f3f8961c55dda4a5b9a70e8a57e63ee89336e3a775a0d95a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a69f043627c8995da9b2792cc63f3edefb4b25c03b448fa8459c1a80fb742da"
    sha256 cellar: :any_skip_relocation, monterey:       "79d2368211290fdc90dbe5237ea4962937996e4894f5cea5370e6252ab59c912"
    sha256 cellar: :any_skip_relocation, big_sur:        "9eb64dbdbcada9d5f6555906a2ad752075f976a44136f46d239ad004003392ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c4b26fa6c7efe563b9790f22e5bf0a08c75d2b2cfb9327bd69e22be77c469e"
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