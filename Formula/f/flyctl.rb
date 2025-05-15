class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.122",
      revision: "86481d0569c4711edaa577073e8c8c1ec9cc9381"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59cf3dbf41d4bda59019248204db1a80dffa87debad1c372c95e690396ddf195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59cf3dbf41d4bda59019248204db1a80dffa87debad1c372c95e690396ddf195"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59cf3dbf41d4bda59019248204db1a80dffa87debad1c372c95e690396ddf195"
    sha256 cellar: :any_skip_relocation, sonoma:        "31927e2f394f0e44bad15f3a7147b35d5d6b6608397526f013300c504bba2197"
    sha256 cellar: :any_skip_relocation, ventura:       "31927e2f394f0e44bad15f3a7147b35d5d6b6608397526f013300c504bba2197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f553367050632f1d30ef391403c12c93eb294fc3d2c062a324e2403e41370e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6deb6f97cbb5144c7af9f84a03baa2ced7c613fd7a47b3301be6afe2648ab2b1"
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