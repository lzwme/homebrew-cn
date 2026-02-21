class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://ghfast.top/https://github.com/rancher/fleet/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "9ed7701f9925fba3cd8907671d458a248138cfecbc28a02d1da5120d4709b552"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fe5b9b3a9cd99bba491b6589c0cbbc131138f6265d00ee426f9d4cfb46c5976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02a5d0b06e139e760dff29980d40dcc2173339a4ba9d2365fd3b45240af5a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2add2a9d0cb5e6d0651b78513e22bc662d441ff4c4f48e5b7c691a65eacc02a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "42af301c6895557ef3e7a96cedb26710e09b754ae64126b014661265f2c43076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526f121f230320dcd7574dea90c0e3fc03204d7a5d1bb40bed7990702e15ac9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6acbd21a792fa330fd32b397792c6a51c61e8c19617d81b79301b203c1c3461"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end