class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.28",
      revision: "7b8546ae9623fde6e64d3964b2042fe25147cca8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b629348425bfbce944ad99c93318b3319bdd951b712b0bdf43a7bc39d8e9de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b629348425bfbce944ad99c93318b3319bdd951b712b0bdf43a7bc39d8e9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b629348425bfbce944ad99c93318b3319bdd951b712b0bdf43a7bc39d8e9de"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f2042d6b7715a572f3d3b650f639ab3f31ed2119699daf073b7b1547dc76740"
    sha256 cellar: :any_skip_relocation, ventura:       "3f2042d6b7715a572f3d3b650f639ab3f31ed2119699daf073b7b1547dc76740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc7f1c2fc92cb8889e8dd487b5fcee49e075241e7cc8dbef876ce79f8df6e83"
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