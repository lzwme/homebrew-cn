class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.558",
      revision: "44f30c4873134c3bae484271344c96204de20c4c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a0eb761d6211592fdf8a4daee32b46dcd9129d65ba164e65da7ebd1759685f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a0eb761d6211592fdf8a4daee32b46dcd9129d65ba164e65da7ebd1759685f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a0eb761d6211592fdf8a4daee32b46dcd9129d65ba164e65da7ebd1759685f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2875f989d78efa8c082e1227e56044309f3a7f37d0fe06b9640ed5647decf8"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2875f989d78efa8c082e1227e56044309f3a7f37d0fe06b9640ed5647decf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2875f989d78efa8c082e1227e56044309f3a7f37d0fe06b9640ed5647decf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ac44ee012ee7a9a69705d0c829c6601dfdc6e0ad5ebd39ad8b82d5379fba098"
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