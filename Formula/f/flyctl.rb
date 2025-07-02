class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.147",
      revision: "1dc18d2ee19ad2f501a95a0958489766925dd4a4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ce0c332d13d5de273b808f90a8730db7f0ce42f987888932633b62fcea6ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7ce0c332d13d5de273b808f90a8730db7f0ce42f987888932633b62fcea6ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7ce0c332d13d5de273b808f90a8730db7f0ce42f987888932633b62fcea6ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5885f123d050234e54685e8aadd5152d53fdca62acbb2bbc0520938ffb30e09"
    sha256 cellar: :any_skip_relocation, ventura:       "a5885f123d050234e54685e8aadd5152d53fdca62acbb2bbc0520938ffb30e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62065cedfbdc59083b5100555aa45b4a7c9e4f1760ba479532901e506cc9551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efab2d1775d0e4e8145396a6aef576501429697540750ca91dfc08a554e2c790"
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