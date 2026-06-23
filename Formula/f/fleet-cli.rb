class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://ghfast.top/https://github.com/rancher/fleet/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "2d4e4fc67631cdfbb6e68a3a01659344555c925385a6d7fac08ab63266b42ea1"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2352db570fae73e46bee350a2c4e86bc38c170f9ee1b60a846d0bb88f84e80c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e7c68173878948e7aa93b739629325bc7a98e5a2d897252af96a78ae6664cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02314e3feca8e62bc8d38a659aee0afa892e2d0f3ff5845ce5ec67d19b91bd8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "643c869d9d5dcc4172bb5053f5c73d330c1697125518b296221940419c5f2b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "348108ed5fa76571eb8049b53d523ad9dea97d18ff62019dbdf104bbe5199104"
    sha256 cellar: :any,                 x86_64_linux:  "3c529942c722959e5dbe7e3edc1e29f4bfef2988406b40d452c750072aaa6811"
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