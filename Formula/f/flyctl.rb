class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.186",
      revision: "8db86c2d21ad0e8189b7ae4862b6ec1bc04dcf43"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5557be512e230fa6250619fa6c703f386170647e87b557440f944dd0852d8f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5557be512e230fa6250619fa6c703f386170647e87b557440f944dd0852d8f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5557be512e230fa6250619fa6c703f386170647e87b557440f944dd0852d8f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c268fa1ac1b25a9e4cb798ee4c19a273171e98d0cf5957b818fe34949f5d305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466e436b881375e56adcfc03ffbfdf468e58487c0a946901525ea08571c942bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a1c593db0005edbaab3cd4a2e837bb9201ae3e51c68f6714d2b29a0477cef1"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end