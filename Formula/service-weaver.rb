class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.6.0.tar.gz"
    sha256 "101c5be088e3633fd5bdecc8636cf4c732d7c9dc3b53a1b3e0e4d3cd89d25fd0"

    resource "weaver-gke" do
      url "https://ghproxy.com/https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.5.3.tar.gz"
      sha256 "497ead64073fdbffaab15a77e71d55942b5bbd3f221eb9bc7595da57060e1b65"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "362ca77fc3901deb3e069a942deff444476f9ccead1512476d48b073432eb090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd5563824bec987e381bfeb72d809350a2f1bbdcf15726008a5b45e1a846b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2b839beaa1993da22eb9004fa0e1cd23a7f2d5eccc33240837be901911571a2"
    sha256 cellar: :any_skip_relocation, ventura:        "09046354b6c6a47cd15b93a010619a7c9d2509df1eedfd0a777949327ce32a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "45e9d2f51167ab89489d85ba38888a1c602e87a2845f70f92a2dc70fc2e367a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "711b8f4773582390263deba0fb79584bca5f71187fab5d8442f31ed1b45fe651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20e0498aa68e640e38e21be10cd6ff2432b04f7df5648b675ef9ce3dad05dde"
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