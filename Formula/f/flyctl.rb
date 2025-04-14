class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.102",
      revision: "9f41af1ac22fc898a48e6c1024449a2f9fd5ef53"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61107138d816f398d74ba723b36cba4a0c867aa08da37e8c792fbd6fffee58ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61107138d816f398d74ba723b36cba4a0c867aa08da37e8c792fbd6fffee58ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61107138d816f398d74ba723b36cba4a0c867aa08da37e8c792fbd6fffee58ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "7648d5ae0891d98d4734a477aabf367dfd17f676c89cdd543ea7ec955626ad57"
    sha256 cellar: :any_skip_relocation, ventura:       "7648d5ae0891d98d4734a477aabf367dfd17f676c89cdd543ea7ec955626ad57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eae4cd67e86596ec692dad6511aff4555bee96c314137db150a47b1b585ba16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c7a6b749853706ec1d611791b66da097275934763bd7aa257a825551d62306"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end