class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.128",
      revision: "6cf80bccc8832537d4f50aa6c19738d53d308c18"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad081f9ac3263d5d2470a5ecf535ddf1620856ac0d41e4392a4cab54d5fb64b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad081f9ac3263d5d2470a5ecf535ddf1620856ac0d41e4392a4cab54d5fb64b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad081f9ac3263d5d2470a5ecf535ddf1620856ac0d41e4392a4cab54d5fb64b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef7d193c4516d193fc062db5e077a541b6e5eddbce28b55dbea531cac2acf611"
    sha256 cellar: :any_skip_relocation, ventura:        "ef7d193c4516d193fc062db5e077a541b6e5eddbce28b55dbea531cac2acf611"
    sha256 cellar: :any_skip_relocation, monterey:       "ef7d193c4516d193fc062db5e077a541b6e5eddbce28b55dbea531cac2acf611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f760396c80552f756dfa939b713610a30e1c883b3e25e916ac0b6e1247edf5f8"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end