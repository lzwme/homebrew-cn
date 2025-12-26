class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghfast.top/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "acb6eb456ef94f39ae11a61e67b123a72ab1c64ba3825822f058083b9d44703f"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80aff4481b56e2bcef6162956a3dcd1562fb3c422b4ec628995819b813914e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af38b91deaa250aec770810349c1d4d0ee24d52666cf91feccf79e1402ccaa47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33297c988c7b9f1d0337ef5cc2a062945da06e5e84e5e136ce76b9e532dca096"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bee0c81a4ab6023ac5f4d896510162f3e1f17f9a5e688a6ac5bb81799e2e9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4dbf1f812a76e811948ddbf1b9b4d6d5d5cd7ece54dc39b873affa77e8dfd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9a667bb699f3089fddc5bac0fd0d2c5cda92b848d52089ce5344b13895d708"
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

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end