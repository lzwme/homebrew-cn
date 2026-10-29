class GiteaImporter < Formula
  desc "CLI to migrate repositories from GitHub, GitLab and Gitea into Gitea"
  homepage "https://gitea.com/gitea/importer"
  url "https://gitea.com/gitea/importer/archive/v0.3.0.tar.gz"
  sha256 "d6b3c742da398589f63d9ebdf664df1a7220745c71e974f9a6aa101c5754c8da"
  license "MIT"
  head "https://gitea.com/gitea/importer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84fa642a19a871916692d93e23b55c2609955003c750ddedbe93cf33daf8be99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84fa642a19a871916692d93e23b55c2609955003c750ddedbe93cf33daf8be99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84fa642a19a871916692d93e23b55c2609955003c750ddedbe93cf33daf8be99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80534bc21b60d787c6a56cf1e0c312d27427f95f204883080e52758c6c54e63a"
    sha256 cellar: :any,                 x86_64_linux:      "cd6f190727cdb0698fbb5f4c16fde4d2c3af00dd5c08739d31d9938b351cef1b"
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
    assert_match "Get \"#{url}/api/v1/", output
  end
end