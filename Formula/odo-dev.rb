class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.12.0",
      revision: "c0127ce2011fa4506816c1516adf3845044daf67"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b0a9092b49d4ba07fe3a849475f0b753521bfb6fd24a2c334b3a8e4854bf6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21a6d68a4648ebd522f9d4c7f93e0628db68b0c063a6fe8a4e8cf6d8fbc61ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ea2d66be2903fc52c32e386081fc8e9b69839016a6ea2623cc3d9dfde015455"
    sha256 cellar: :any_skip_relocation, ventura:        "3eda52349080ae05f2dfe93507a496ae93be5db00073dc88992423d3a095035e"
    sha256 cellar: :any_skip_relocation, monterey:       "b308a4902a85176ea82acc4f7bd8f0f4c4f8f03a91896fb98212c7d2234c0955"
    sha256 cellar: :any_skip_relocation, big_sur:        "28820f66c54df85328b47705523020594abf109715a1361f98a0aaadac036cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5b4b0e18889820b3c10cfd5c5e077959b04ff234e2be00fbebacc8a2b54ebc"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_predicate testpath/"devfile.yaml", :exist?

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "✗  unable to access the cluster", dev_output
  end
end