class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.20.tar.gz"
  sha256 "c6bafc721f171ee1d7f5cf57cc54e5836752306ccfd2ede0e8643deb79b86590"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2903e791e05b7bbc8568f180da86bab9012471c900b4f859929e2c85699b6cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0097f813c065fb1c666085782134b0020cbf015a74a28589b61a30165c93be35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a5a163d49999216001051db573d891b12f80cb1800971b8bc0353a806473ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c592f40fcbd2054e5b0b6bd1a6e6c884ffb10b920e9e37d2c1233cfc35910b7"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3ea28b82ee31efa9f6b816698423bef38271e9f2f2505570cfc3f9dd1705cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf8fcd201a0b85f3575320a563179cd45f7102211f2d31a8be68e8f60861c55"
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

    generate_completions_from_executable(bin"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}cilium hubble enable 2>&1", 1))
  end
end