class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.16.0",
      revision: "4b074c7014b5101f0aa83800c5987f5e4378e5be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79af3d3884a7e31cc84929ff8668eda166e224bbbda0e24029e8a23fc572049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79af3d3884a7e31cc84929ff8668eda166e224bbbda0e24029e8a23fc572049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d79af3d3884a7e31cc84929ff8668eda166e224bbbda0e24029e8a23fc572049"
    sha256 cellar: :any_skip_relocation, ventura:        "2b9439adaeee684f8f600115d40b80d80c65be967bdc6a7586663f5f5c4c4101"
    sha256 cellar: :any_skip_relocation, monterey:       "2b9439adaeee684f8f600115d40b80d80c65be967bdc6a7586663f5f5c4c4101"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b9439adaeee684f8f600115d40b80d80c65be967bdc6a7586663f5f5c4c4101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feeb23766e2f78ac42dd3b030be6fdd3c90fab0ad6ec89ca302fe5f07bc1cbd4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/argoproj-labs/argocd-vault-plugin/version.Version=#{version}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"argocd-vault-plugin", "completion")
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end