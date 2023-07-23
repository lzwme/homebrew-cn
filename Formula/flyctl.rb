class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.64",
      revision: "1ddff4ccdd97ca10913306db4733c1d486b38209"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6b549cc868ddbcd38a648e385621528606e50638f04c124fc7da5436150464c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6b549cc868ddbcd38a648e385621528606e50638f04c124fc7da5436150464c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6b549cc868ddbcd38a648e385621528606e50638f04c124fc7da5436150464c"
    sha256 cellar: :any_skip_relocation, ventura:        "7e1a0b1285fc70990138e546fa9f966f269019390e35ed3bee099d526f04afc9"
    sha256 cellar: :any_skip_relocation, monterey:       "7e1a0b1285fc70990138e546fa9f966f269019390e35ed3bee099d526f04afc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e1a0b1285fc70990138e546fa9f966f269019390e35ed3bee099d526f04afc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9612605c766d985bf349656f6dd2294199c0ad972e3d9b295fc0fb3e9eb857e"
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