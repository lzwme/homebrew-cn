class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://ghfast.top/https://github.com/rancher/fleet/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "608fea6e06f25b247620e58b88604128d3b81f06f13bdd53456ed6c1e87008e5"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c20b9cb928a05c8a088266decf9ad4b68f9849a5e95f54c1b8ab00dbd7ac42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82eda0b43103b5128cd89660e1e38039e88303c35f98973f657386a4d01659e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7c061cf67d326efb0ac28106dcdd5b388f2a9121db9da8f0bcf2a0e91152d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "baaeb99a0d0970469d515b13d0b4b275295ab48f01ef87beaa66129d1fc8043d"
    sha256 cellar: :any_skip_relocation, ventura:       "05074d70932685aa8e40b3807e93e8371bcd51c28588156d75b35542296e687d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fefbc30c1352bcd5618a7afa5a2a0704f8d242f9f4dd51e9d6d16470f24c39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c8a06db6db4063eb34bdaf6b13c7dd34fb3d0c3da32ee8f64bba45cea2e2e3"
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