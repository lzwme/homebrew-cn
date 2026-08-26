class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.10.1.tar.gz"
  sha256 "b749516d50ce24c55aea7d4eb25d774fcb91a65ef313e489f469aeca00a20d6c"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a972c43c5234aa00a074b91e61a4729269b008ee8fa31ca937c27d4767b22465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a972c43c5234aa00a074b91e61a4729269b008ee8fa31ca937c27d4767b22465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a972c43c5234aa00a074b91e61a4729269b008ee8fa31ca937c27d4767b22465"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30bf1aa367d3f85e05513973aacbfcb8af3bc215321b531e5a5cb0507769a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3d607489145313a065261af7355a75311f95bdfb7120f2c6eab52768fca742e"
    sha256 cellar: :any,                 x86_64_linux:  "cc9b3d4af61a91e2ae73695733ff5ebb64eba394759e2b15e2a50b6358fe6d52"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end