class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.9.tar.gz"
  sha256 "60ca370c4dc587abd07766a2457e922ae23e3fc20017de4e8333c3f501f9670e"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a5a5bb34c516a3a3ee7ed272ab41dd98c833f0158b570fdb4690b64148ba6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d105fc81aedb5439d63d154d678004c7ae535e8936ff0056c098967bc84b44b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f806edf0ecedb02a2b007e7f09783f80d78521676477ca1dd2801ba48cd82b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ae6edfbc1ddf0f89dc4485749369f724deba4ca1bc662eea37f2fee08aab62c"
    sha256 cellar: :any_skip_relocation, ventura:        "ad6da47c0a2ea6fe6a0095494cae44e90fd0a0182cade4d1209369c8bd37caa8"
    sha256 cellar: :any_skip_relocation, monterey:       "096393d29af8ab9ed80d7f8fc148994801f36b8fed2b3f267d1c2d81a12d2840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c282a52c07bf5aa95e0f6c22e310b183d1c003dd47aa1bb6ba48f6df624a7a29"
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