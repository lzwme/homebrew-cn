class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghfast.top/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "32db3585fc97362adaa1fa2d9eb841670e087ff8f20bf354fa8766fbf65b070c"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc59f21472ed50c23b1461e97d2b3bc1e54a2c59b96c67866471bd075a41228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f55b172d226396310ec68f24edee0ace977cdc83ea6a63dedf3f91bdaeccf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18a903b3a4cfe8ce041ebbadc1353e88addc349c0453fe9c0d7eb3008b4909be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4668c62f76764c0ff8b3632abb8e84482b461449ef3210a95ec91f47305dcdb4"
    sha256 cellar: :any_skip_relocation, ventura:       "61085e5cf627add2a14a915973e1d3f264ff32c0fbf1f40910e21de95424ea98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33150719f02515ad8372c5296396291c1ef5e4afa61efe9445912b7fc99378db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a9715ec0ad68e03f469782f07675175d5c9af15385137399a65e7a543b0866"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https://ghfast.top/https://raw.githubusercontent.com/cilium/cilium/main/stable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
      -X github.com/cilium/cilium/cilium-cli/defaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end