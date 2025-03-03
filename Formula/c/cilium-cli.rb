class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.18.0.tar.gz"
  sha256 "c00720fee4a6b709cf81d0107d7fab1bb273fb4f565a9ecf397e393bae7500d0"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a809e1f77254337ea39d11cf234163696384a32b73a2d6e166ed8513686c2b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07fa8d7a00b930f3ca32ab72308b5cc5f158918c6fd05f2f39f2aac4747a6766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4076110a35a97f9c2fec03c2f2fef4870b7909799fa3544133fdb1f7a9830ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded081fa1c920c38c2430825f8bc3fded2fe0650fe81084ecee88014266a76b9"
    sha256 cellar: :any_skip_relocation, ventura:       "aa451dfb0ec453af601d53bccccdd56b4e72a140a0578d3eebb148ae6a4a6680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae76cca134cece7a915edf60b3a7b879380298116ccf5ce7b0cb690c3f940b29"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https:raw.githubusercontent.comciliumciliummainstable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.comciliumciliumcilium-clidefaults.CLIVersion=v#{version}
      -X github.comciliumciliumcilium-clidefaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"cilium"), ".cmdcilium"

    generate_completions_from_executable(bin"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end