class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.22",
      revision: "ab42503d3e1d8d49dcfaea89959a6f665abff9a1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dadff647e8542059de715027e78f08c2715cfccbb2951f3dea268a85b78e817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dadff647e8542059de715027e78f08c2715cfccbb2951f3dea268a85b78e817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dadff647e8542059de715027e78f08c2715cfccbb2951f3dea268a85b78e817"
    sha256 cellar: :any_skip_relocation, sonoma:        "72422461a99a1879d6e5673e84e72f59c696a7c10a40dd68ef1f43185907bc21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0cbf524e43a3f034075467f20e5ebdfb7911ffbff408290bffb78dbccb4df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004cfb1eb71ddebba653e125ad4d6bde27549c4f569152fc117209b533206bb3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end