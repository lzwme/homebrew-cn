class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https:argocd-vault-plugin.readthedocs.io"
  url "https:github.comargoproj-labsargocd-vault-plugin.git",
      tag:      "v1.18.0",
      revision: "3986b0794cd5f217add8691a32f9276ba6b79767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5d7aadc7ee30d2276e319e552ee91f0a6be1191393d36d1f67e887528a66a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d7aadc7ee30d2276e319e552ee91f0a6be1191393d36d1f67e887528a66a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d7aadc7ee30d2276e319e552ee91f0a6be1191393d36d1f67e887528a66a2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c2ed23d8554b35ed8f60ac11b7b50b4d2c49db3e7a5628b3c54014b87a4d0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "9c2ed23d8554b35ed8f60ac11b7b50b4d2c49db3e7a5628b3c54014b87a4d0ee"
    sha256 cellar: :any_skip_relocation, monterey:       "9c2ed23d8554b35ed8f60ac11b7b50b4d2c49db3e7a5628b3c54014b87a4d0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2902f8c7b318259358de092c009523cdeae51b9909fc47320a8aff390ed736"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comargoproj-labsargocd-vault-pluginversion.Version=#{version}
      -X github.comargoproj-labsargocd-vault-pluginversion.BuildDate=#{time.iso8601}
      -X github.comargoproj-labsargocd-vault-pluginversion.CommitSHA=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"argocd-vault-plugin", "completion")
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}argocd-vault-plugin --help")

    touch testpath"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}argocd-vault-plugin generate .empty.yaml 2>&1", 1)
  end
end