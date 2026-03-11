class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.20",
      revision: "975af7b195ddbd66efb4523e66077df13a6341b5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1541de631bde059e3c6f7635a61aaf0c73cfb98018040531de0f10d56402394c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1541de631bde059e3c6f7635a61aaf0c73cfb98018040531de0f10d56402394c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1541de631bde059e3c6f7635a61aaf0c73cfb98018040531de0f10d56402394c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc65c1b3b65230300abbe81e29b9f7561abb5389809268ddb9d36eb959456154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1945324829dea4f89c7abaa36130f81e8e0c58f2b28af05d2e2a44845f582c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df28f9a1d4976475ecc11f5f816d326a0931fe8d864990fc301cf28b93d8a947"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end