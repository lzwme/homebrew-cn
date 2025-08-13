class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.170",
      revision: "7986a9f6360ff8d7b57ee1c72fa833a4193a605f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5b9a5e844900a8b888aad78dbd29f58a82f68672b46d757dc161236d124308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a5b9a5e844900a8b888aad78dbd29f58a82f68672b46d757dc161236d124308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a5b9a5e844900a8b888aad78dbd29f58a82f68672b46d757dc161236d124308"
    sha256 cellar: :any_skip_relocation, sonoma:        "08e88c23370def171943dd7f2cff9374d0c231303aa80c7e1ca13ee32811d961"
    sha256 cellar: :any_skip_relocation, ventura:       "08e88c23370def171943dd7f2cff9374d0c231303aa80c7e1ca13ee32811d961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b8127fbd493902120dd943300e78137d98363b40dea1df285b405fed0587dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db143b3ee2f7b7407a49c425707c17d3eb6e9dbf8dccbac31e630e83893f8ca1"
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
  end
end