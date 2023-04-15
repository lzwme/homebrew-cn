class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.521",
      revision: "4523084fae2442e60c36f947528e88bfa6e6a621"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec7df3be2fc17aa4c4aff073c5c41d8297aa742fc57c78ffb72c2c0e93576553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7df3be2fc17aa4c4aff073c5c41d8297aa742fc57c78ffb72c2c0e93576553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec7df3be2fc17aa4c4aff073c5c41d8297aa742fc57c78ffb72c2c0e93576553"
    sha256 cellar: :any_skip_relocation, ventura:        "2d99a49c2fd7ee511058d27b6e8db31eaad05302f7dd9127a366aba7f50ddec4"
    sha256 cellar: :any_skip_relocation, monterey:       "2d99a49c2fd7ee511058d27b6e8db31eaad05302f7dd9127a366aba7f50ddec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d99a49c2fd7ee511058d27b6e8db31eaad05302f7dd9127a366aba7f50ddec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07cf958b7ffc94de0fb35298370d232533f1ba51403832b819850b2fc9c777b9"
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