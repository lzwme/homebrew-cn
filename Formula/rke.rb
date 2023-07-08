class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://ghproxy.com/https://github.com/rancher/rke/archive/v1.4.7.tar.gz"
  sha256 "3feeea43d4a53d4d1d7085c3b25549e7d2bd76570864dfaea69886d5f1c789ff"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times). We normally avoid checking the releases
  # page because pagination can cause problems but this is our only choice.
  livecheck do
    url "https://github.com/rancher/rke/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5183cf927c154be71ee54742c42bc67edfeabe118eaafc698fc4c6bef1acc343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d1341ac02690e60bfe998122a4fce51b347aba0af4c41d604428323ff33dd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20280387e59d55ab446d4cd5c1f9ef514d044cc6ff4d48b4d688aabacbe3cb22"
    sha256 cellar: :any_skip_relocation, ventura:        "72e596353e3c130e0b97f78a3ec5d551976399e85511250b7e2ba0b7f8891fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9aa92f9cf8827fdc9fefc658495deb196b6f183f859a8dd146a0c0fb9144c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a7c419550d87a31ca2ad66c9488d0ac05d35e1849f12f8b8347a496ed65417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a72472378d442a5d671580bc13a766606e35c69ac6e1fb70f59e32530b38dab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end