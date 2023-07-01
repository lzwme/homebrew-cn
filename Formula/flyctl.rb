class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.45",
      revision: "e1fdcc554f3d90b5084d34a5399289afbfe77b2f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ce4f96ad499d4636b6b982212276787bd38f4041b4d9a38dd40e8496ff608d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ce4f96ad499d4636b6b982212276787bd38f4041b4d9a38dd40e8496ff608d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ce4f96ad499d4636b6b982212276787bd38f4041b4d9a38dd40e8496ff608d"
    sha256 cellar: :any_skip_relocation, ventura:        "e232f49f8642571ce27cd98ad8bea5b5db1679137196316933c53fc9f505f933"
    sha256 cellar: :any_skip_relocation, monterey:       "e232f49f8642571ce27cd98ad8bea5b5db1679137196316933c53fc9f505f933"
    sha256 cellar: :any_skip_relocation, big_sur:        "e232f49f8642571ce27cd98ad8bea5b5db1679137196316933c53fc9f505f933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cb43b2da7a9e90c0d06ea9c08bbd436a79282797fded09d206bc736a386863"
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