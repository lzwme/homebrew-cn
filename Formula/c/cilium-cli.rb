class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.13.tar.gz"
  sha256 "a2ed98a370d42c7040a5dbefa69c3edfbd143c00412a00a1f980b5e1c203ae1f"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d592ca4915dc83188db833e39dbc5ad23070af90a1c36686875778a9338f6f4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1be38ce6a23e1d339fb77ddc6621c7e0f7e4b13f860e55899ecc50ece61fe082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c6a38c6a7a5d157c4ccfd07698f37ef2b8d2052341244b0914e59b1d9c88b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a217ca9efd69cfe22f7440d54293ab3e7a43d5784942459e29b7bb28173e39f7"
    sha256 cellar: :any_skip_relocation, ventura:        "6055ede55fe6692bdc9b91ffff43de60fde8eb9508740f212c5b9d3612da5491"
    sha256 cellar: :any_skip_relocation, monterey:       "cc579bfc47c80eb821efc0b40a65c5094e71adb1a244cd46d0194bb4763a2b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "810a57c3f3769b8e0ce84044abc3e7a6d53a3043d3d9e5b89063945d18cabc6f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumcilium-clidefaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"cilium"), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end