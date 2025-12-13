class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://ghfast.top/https://github.com/rancher/fleet/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "63408c6c225d43fea36410defe3b7d56f17e5c84b857eaa2fae97fdaeb80d20d"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bd5f66abe885a73cf5d8687ee1ddf464ce25b357a73d6d7e82ab9357371d021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9af480fac1f38d90d80490650e628ba43a89a05214f5de12b7f24cdfc7401e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb7d3d45c4bcd4f17b46436779501a59519961ab339c1162d918000fdfa3a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd9766cce33257fe91269b5d911eeda75e13d0e1ab864728dae6392fdaa7eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1b9db4ba6ad2f2d289595744a1f5b3d5ef96ff469f93b1c194a777b38b1789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d511377787600be65b2a0ef5f236b58252d2476e4f5070a7985a3cda1b422b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end