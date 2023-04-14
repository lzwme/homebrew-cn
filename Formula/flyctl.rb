class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.519",
      revision: "33da95aa31a5bd6e51e578670459d8d55408128b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a621bd67b00e365280e5c3395178e7addb88d962aa165881bda2207c25e29adc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a621bd67b00e365280e5c3395178e7addb88d962aa165881bda2207c25e29adc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a621bd67b00e365280e5c3395178e7addb88d962aa165881bda2207c25e29adc"
    sha256 cellar: :any_skip_relocation, ventura:        "5293d190f32de74d9a28a94ebd4186ecd0727443f0d887637c44efe02c943502"
    sha256 cellar: :any_skip_relocation, monterey:       "5293d190f32de74d9a28a94ebd4186ecd0727443f0d887637c44efe02c943502"
    sha256 cellar: :any_skip_relocation, big_sur:        "5293d190f32de74d9a28a94ebd4186ecd0727443f0d887637c44efe02c943502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f2364db3bcdb06044f63a75dfca78032c4174b572dd8fea3d463f4e5f1f40b4"
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
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end