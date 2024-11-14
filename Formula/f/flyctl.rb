class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.37",
      revision: "44a891232a031034db966db3fab83399d5245597"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de67e3483e3c7276bf5b1b5d3f02696f9d16a6de20fa1645cf0efcdda22d0556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de67e3483e3c7276bf5b1b5d3f02696f9d16a6de20fa1645cf0efcdda22d0556"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de67e3483e3c7276bf5b1b5d3f02696f9d16a6de20fa1645cf0efcdda22d0556"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb7bc540e5cf5a8839a989b434cbfd259ad5c539ad91ad2a96885ae7c0d73f9"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb7bc540e5cf5a8839a989b434cbfd259ad5c539ad91ad2a96885ae7c0d73f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369be7f820932cbd46eb1fd4820fdd99578284e00716bc8c7e3a8165e5256cb7"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end