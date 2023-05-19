class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.12.0.tar.gz"
    sha256 "aa0f9aa4108487cf0f79bf80378d0e8689758e3799338cdcd7c6f13b1ec96ede"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.12.0.tar.gz"
      sha256 "6d363ef036824269412e7b91f0f49c4966b0b1481f1bdd045ebab2410c39ccb8"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154c72caea1d2ffcf03239da173da98e8a0502d9187963b17dc3aaf4cbad78dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7815f33b2f6ed969c16829fca2b71ccbe9f2bf7df362582d98074500993b9f04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "473e95cb854620f8a25400393b6f691bf57813872248f80270ebe633217e766e"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0640b15191085b6be04d7e4046ef42ee1a79f50e912b11cdd83ea527dd6c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "98c3ca7c41afe03a0c45e37836ba845cdf13fcf52ac4e94a28e581770627b207"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb8c4a1713e94f8162ed10d63572f2f6ba59530af8a7b70a0a4a0edc9008b22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b276c572e653e5cfe63fe312bc6b05a55a1a204e906e408eb13774b637c24a50"
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