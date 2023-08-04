class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.70",
      revision: "9ebc50c4f7f000a3e0a1625ce6a01a508b3e181f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621824851bf081ed205fadc7752ec8eaaa46831ee202cf9a4ec92718716e9eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621824851bf081ed205fadc7752ec8eaaa46831ee202cf9a4ec92718716e9eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621824851bf081ed205fadc7752ec8eaaa46831ee202cf9a4ec92718716e9eea"
    sha256 cellar: :any_skip_relocation, ventura:        "a73900a024386df0b5050c1d8c15471d0f2a6b9ff98d8c9fab7ed58e0c21c16b"
    sha256 cellar: :any_skip_relocation, monterey:       "a73900a024386df0b5050c1d8c15471d0f2a6b9ff98d8c9fab7ed58e0c21c16b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73900a024386df0b5050c1d8c15471d0f2a6b9ff98d8c9fab7ed58e0c21c16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924551babb14bab03692680e6d8547e372f1e9ec1fdea598c80cce50aea74b57"
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