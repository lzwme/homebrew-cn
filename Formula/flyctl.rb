class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.68",
      revision: "8a1757c2e652cc3c2a4d90280ab6ac021e7b1919"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e497fa8fb63112094f9e4d5a3f155ee96b9512169768c98a48449c8649353cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e497fa8fb63112094f9e4d5a3f155ee96b9512169768c98a48449c8649353cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e497fa8fb63112094f9e4d5a3f155ee96b9512169768c98a48449c8649353cc"
    sha256 cellar: :any_skip_relocation, ventura:        "ff7fba5a171784a1e07b35067270faf89abc34eb46e947bac4bf57365b0b2834"
    sha256 cellar: :any_skip_relocation, monterey:       "ff7fba5a171784a1e07b35067270faf89abc34eb46e947bac4bf57365b0b2834"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff7fba5a171784a1e07b35067270faf89abc34eb46e947bac4bf57365b0b2834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d05ada36fae08e85f9cb66734f474cef5acebe133c8b9d157ec4c53f9ac45125"
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