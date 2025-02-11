class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.77",
      revision: "cd05a978ef72ecceca6925c32322fe2373cebc45"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203804a048f13435abf1b3434629346f85e203681a63efeea087e47c54c6298f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203804a048f13435abf1b3434629346f85e203681a63efeea087e47c54c6298f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "203804a048f13435abf1b3434629346f85e203681a63efeea087e47c54c6298f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5f291354c19c8fb7d3cb05619673170239ed386edd251aa290df745b99fa73"
    sha256 cellar: :any_skip_relocation, ventura:       "6e5f291354c19c8fb7d3cb05619673170239ed386edd251aa290df745b99fa73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe6d00beefdd25b4c946b79ed528dea69db1a534ade7378b36aafaa42f0b625"
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