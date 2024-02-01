class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.15.21.tar.gz"
  sha256 "d1b0cba6ae381c89f7d8ecc6b6d73b56d87de891ee0ab43c12275fc7e9e59ea1"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a92fff727aeaa6a45e9df0a17ba80ea3c7a89ed04e4fe71756e9b5c4eb743fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7892ac3fc62eb858463f0d3cd7c7a6d354d9f79288fba5153c46221a918031ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8301ffd6491ce253cf63bb8f5d45a3436340d060f3559c0c5f91d051afbd2e5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ece2e05a30911d224f2799e812ecf51033731d5b65a7463d2a0cf55aa68b276"
    sha256 cellar: :any_skip_relocation, ventura:        "38391cf600cab617a9b1cf358d729d5ba6194d5bd11f8f3cde22bc629c15dd71"
    sha256 cellar: :any_skip_relocation, monterey:       "f987f91df607a12a07a7263052b05a648e341acb9068642bbc7ca18bfc5a804e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac4e6ed64385e2c34687997b005d5a2ad37277afc6f32ce4a64443a3a2a88b8"
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