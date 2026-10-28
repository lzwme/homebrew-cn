class GiteaImporter < Formula
  desc "CLI to migrate repositories from GitHub, GitLab and Gitea into Gitea"
  homepage "https://gitea.com/gitea/importer"
  url "https://gitea.com/gitea/importer/archive/v0.1.0.tar.gz"
  sha256 "aee0711b52d1822f55499b4f5d0160fd6decb95224f8cb6ee1b89c8c2d082dcf"
  license "MIT"
  head "https://gitea.com/gitea/importer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "623d37e32842259c52303c232800e41debbe3a111055fb304106e52794c75944"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "623d37e32842259c52303c232800e41debbe3a111055fb304106e52794c75944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "623d37e32842259c52303c232800e41debbe3a111055fb304106e52794c75944"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8a8d2bd31e581c29b9d8ac0c71220e8d8abb5e71c6f854d32c6f3b6e667658f"
    sha256 cellar: :any,                 x86_64_linux:      "939df9e565f5eec74afc30ed5d89ddd1d796ba99446b56cbdc1a278bc9d404eb"
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