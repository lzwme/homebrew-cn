class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.15.20.tar.gz"
  sha256 "75853e3fd1ed0d060cebb1f13becae61d848dcf6f6122c6aeaf561cee62fc382"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "725ca0abc40fca868355ba833d0043e45f3fb1e8565abdf4dffbd9a4f93f33a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8859f7fae25de0b320d0b6c85b85fe0094ba6a3ea517f829e54745b07f9ec13d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a3b168a8a93485e9808ba4dd45b37650fb4502474c3bc7ae953d8154e13c18"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ac478bb0c6b9623d9ded67e820fbbfa93b1bc07f684b420303362f87acce1b4"
    sha256 cellar: :any_skip_relocation, ventura:        "c587113f411f62ad9697df0c8ea8c43d25a54626e5230d9ae44073659d96f43d"
    sha256 cellar: :any_skip_relocation, monterey:       "a0acdfee7c90c38be45c64e7afdfe672c7acdd47ee9280bafb1146416eac282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695a75b6e32c373c8b34517ad48e950c8d499949044b6df0c67e4a4ea168fe0f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clicli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin"cilium", ldflags: ldflags), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end