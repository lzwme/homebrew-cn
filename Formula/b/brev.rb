class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.259.tar.gz"
  sha256 "159cc408c32fcbb76f9eff4f5b213530fbb1fa21ffe2cdf638fa48cba5d1f5b4"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49b67fa0e77d7690af4a9315713a6b204fcf305788fbb9a0676a9fb87ba25880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d9bbd983d3195894e6ac3716d63fca854273c9b4e20e7b82208afb5462cb03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e9c120b67bfa8e785306d44c3769046acc2367d46c36ded72c3cccf33c6b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "c65a99bea3f5d72b9a596ced8ee9d6b676ce13259b25d16889758ff6bfb4ed93"
    sha256 cellar: :any_skip_relocation, monterey:       "df4fa9fbabaa8cc1e47ef19d8e9f24c03abd3ceb9ce1772d64792a0a5f64d38f"
    sha256 cellar: :any_skip_relocation, big_sur:        "74843faaf5128569f390703cc709f6efa2b6b5e48a66dd7fa35ae3f87b331330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd7edbbaaae536d4533ea37ddfbee7d60cab903eac9c4edee38c399dc31a954"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end