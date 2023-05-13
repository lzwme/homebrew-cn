class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.3",
      revision: "d42ac204cb0f00d3d0039aab6c67dd66eb2b7ba2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fceb14eff312285bc6209f4ac547de271f850ead3aaf316c7af072a36d0dd0f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fceb14eff312285bc6209f4ac547de271f850ead3aaf316c7af072a36d0dd0f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fceb14eff312285bc6209f4ac547de271f850ead3aaf316c7af072a36d0dd0f1"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd1a8c365350aa799e33602bc4812a7bbd55e2dd55dd302835835f7fc9ac7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd1a8c365350aa799e33602bc4812a7bbd55e2dd55dd302835835f7fc9ac7d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcd1a8c365350aa799e33602bc4812a7bbd55e2dd55dd302835835f7fc9ac7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96783571aae959692f8c0db952bfa92f447bad43e02ffe2b774def30453ffb52"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end