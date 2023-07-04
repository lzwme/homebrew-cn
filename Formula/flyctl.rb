class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.47",
      revision: "c39ca26fffe52f54832e94c8767995d2ba3a41c3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff81ea8500a6d22b8c7ae642224e71dafd18615ffc862711790b1e1dd734bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff81ea8500a6d22b8c7ae642224e71dafd18615ffc862711790b1e1dd734bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dff81ea8500a6d22b8c7ae642224e71dafd18615ffc862711790b1e1dd734bdc"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e437fd076e6562176c292b24fb8b094bf054b9c8dcb89e8b640564ca853dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "f4e437fd076e6562176c292b24fb8b094bf054b9c8dcb89e8b640564ca853dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4e437fd076e6562176c292b24fb8b094bf054b9c8dcb89e8b640564ca853dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f86f9922e463c65bb0f3f321ae92213d1fe6cc29cfad5e422306cd0dcce54adc"
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