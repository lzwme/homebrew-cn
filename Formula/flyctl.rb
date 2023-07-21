class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.63",
      revision: "3996140193a9de435c13d9e21d26e6742f0866c1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df85948ea0d8683beae9728ee3bf8f43fe8a7b63b48113c9754c5bc5cc8203c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df85948ea0d8683beae9728ee3bf8f43fe8a7b63b48113c9754c5bc5cc8203c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df85948ea0d8683beae9728ee3bf8f43fe8a7b63b48113c9754c5bc5cc8203c6"
    sha256 cellar: :any_skip_relocation, ventura:        "f60fbc4fad198aac4b9d27684f7d05ea27536ef63308471f2773ba50f4f8d2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "f60fbc4fad198aac4b9d27684f7d05ea27536ef63308471f2773ba50f4f8d2a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f60fbc4fad198aac4b9d27684f7d05ea27536ef63308471f2773ba50f4f8d2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9649903103484eb2d0dd2713359f123bd808d04ef9f6b442b9e75b57f397db"
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