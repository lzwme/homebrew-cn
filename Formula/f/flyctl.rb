class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.72",
      revision: "c0a61b8d482cf6e697ee184544280d1687883da8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b68e442ded7b2ba188eca6efe159cd5059aede51f941bfe9a28b88bf603cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b68e442ded7b2ba188eca6efe159cd5059aede51f941bfe9a28b88bf603cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1b68e442ded7b2ba188eca6efe159cd5059aede51f941bfe9a28b88bf603cd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea515ef1c0ce8c4ec1af9546271ab0d4d79707f607ba2a12cd64f1fba6068dc"
    sha256 cellar: :any_skip_relocation, ventura:       "eea515ef1c0ce8c4ec1af9546271ab0d4d79707f607ba2a12cd64f1fba6068dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fd230a3764ea8ce5cc669aebc330779deab474e76f84d5c3a950b29bdd5f57"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end