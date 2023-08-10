class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.74",
      revision: "8946b50584df1afd587d03ee6146b23c452af60f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d2da8fee6c9d3b99dd97c14216bd2421ab9ceccba7a682a87a0d27bd65d4d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d2da8fee6c9d3b99dd97c14216bd2421ab9ceccba7a682a87a0d27bd65d4d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72d2da8fee6c9d3b99dd97c14216bd2421ab9ceccba7a682a87a0d27bd65d4d6"
    sha256 cellar: :any_skip_relocation, ventura:        "98719fd4b7d231206952e87374ffe73486d5bd9a9a70359b8f94c75090e91bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "98719fd4b7d231206952e87374ffe73486d5bd9a9a70359b8f94c75090e91bd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "98719fd4b7d231206952e87374ffe73486d5bd9a9a70359b8f94c75090e91bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330550281380e48a56c35924e51275154f1aeb37783b9934734f24eb5b8fdbc6"
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