class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.65",
      revision: "7588a62430590fad0221ff6786bd6646fe2f0b15"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11d6860c0442e2b979fbd0885ffec5f4266068f051f4d5b379853bd63eb63cce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d6860c0442e2b979fbd0885ffec5f4266068f051f4d5b379853bd63eb63cce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11d6860c0442e2b979fbd0885ffec5f4266068f051f4d5b379853bd63eb63cce"
    sha256 cellar: :any_skip_relocation, ventura:        "34ee4ea9cfe21ac5a9133fdc72e208e61073c44ed10cd09aa1a75a5cf53997ce"
    sha256 cellar: :any_skip_relocation, monterey:       "34ee4ea9cfe21ac5a9133fdc72e208e61073c44ed10cd09aa1a75a5cf53997ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "34ee4ea9cfe21ac5a9133fdc72e208e61073c44ed10cd09aa1a75a5cf53997ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ffccde338b52d9a0ce8af55787a2aeb7ac350d43e9bc935ee3b91daefc1ae5"
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