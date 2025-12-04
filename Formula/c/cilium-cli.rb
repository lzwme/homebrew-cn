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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "077170347072d02c2336764e25d3e910091bc6a8e8863704e752eebc7f1eb940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71354d3300a4b3ab6c81dacc9f00487dceac749a2b42507bf627eec446be7bf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e69b6fd9b2f2e37d8a6b582e7996a4d251b0ceef9600eb94e99b0ce425cec9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ce402d2a98c9a4e9d6f74141630a93e4286d5aefe7d3f1a97944a9702de23f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9649a30bbb1b1e9056fcac40439a4b12ca52fafa9b96d483281218023b1e1117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0487685cb5f3b9c589f1809af13de35240dcbe07bbae866c6619b5add87f3f24"
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