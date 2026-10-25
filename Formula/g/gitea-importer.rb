class GiteaImporter < Formula
  desc "CLI to migrate repositories from GitHub, GitLab and Gitea into Gitea"
  homepage "https://gitea.com/gitea/importer"
  url "https://gitea.com/gitea/importer/archive/v0.0.2.tar.gz"
  sha256 "2b9e610f34fee685cd57e7104641e00f17115b7c60e06596d5ff66ca33601aba"
  license "MIT"
  head "https://gitea.com/gitea/importer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61dbe0b107c94c5879d3575c862418f9ef01e0314567c38576ee42b59775d5c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61dbe0b107c94c5879d3575c862418f9ef01e0314567c38576ee42b59775d5c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61dbe0b107c94c5879d3575c862418f9ef01e0314567c38576ee42b59775d5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f76203b9547e8d1ea6331805729d3bea86c9a8eda20dd3ae5810627432fca50"
    sha256 cellar: :any,                 x86_64_linux:      "851508b0a6014374ca602c65731d6304670782a342f852dbed49951ce8b5e2a1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X gitea.com/gitea/importer/internal/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-importer version")

    output = shell_output("#{bin}/gitea-importer scan --source-type gitea --source-repos foo/bar 2>&1", 1)
    assert_match "gitea provider requires a token", output

    url = "http://127.0.0.1:#{free_port}"
    args = %W[--source-type gitea --source-url #{url} --source-auth pat://test --source-repos foo/bar]
    output = shell_output("#{bin}/gitea-importer scan #{args.join(" ")} 2>&1", 1)
    assert_match "create gitea client: Get \"#{url}/api/v1/version\"", output
  end
end