class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.78",
      revision: "99362bd29223783a99914becf9c9493787a8bebc"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d65cf07df9a198af62602e5ad7b4674582e632eb614848ce817dafeb520ddf95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65cf07df9a198af62602e5ad7b4674582e632eb614848ce817dafeb520ddf95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d65cf07df9a198af62602e5ad7b4674582e632eb614848ce817dafeb520ddf95"
    sha256 cellar: :any_skip_relocation, ventura:        "3304ac8b29d5cf18720138ee457ad369dae2a22f56c307723e63329f8a0be32c"
    sha256 cellar: :any_skip_relocation, monterey:       "3304ac8b29d5cf18720138ee457ad369dae2a22f56c307723e63329f8a0be32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3304ac8b29d5cf18720138ee457ad369dae2a22f56c307723e63329f8a0be32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e157858e6835825d55423a3a7af7de91fbd3370eeedf207e1aacee41621cdb4"
  end

  # go 1.21.0 support bug report, https://github.com/superfly/flyctl/issues/2688
  depends_on "go@1.20" => :build

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