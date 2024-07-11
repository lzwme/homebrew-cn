class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.12.tar.gz"
  sha256 "e9f902bda1b4200b6ac9fda30ed438b57711b3508be8f35828f86a065460eefa"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fbed9461160480d311d33ddaba31a31b0dff3500a783656ec69e8e35ef2db7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d491b4185fcebca37f13aa50b4954167cc86cdbe6f23453a17c4be2af5611f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f3c60698a7318d42d567b82dfa97390e377958f6f9900b8592174e8fbfdb9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "36bd35e5ba53483d4a4d5b7098b53ec1c03723e0194e3e92c1160d1c902952b2"
    sha256 cellar: :any_skip_relocation, ventura:        "d763828a7e4fa368a4416e32dcf8c974434fbab30264a8f6df1e5d583bb33a49"
    sha256 cellar: :any_skip_relocation, monterey:       "b1bc455eec51fd82518441a54e13978a1dc211dccbf4c59c317f2e73b6efcf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d46bf072a57b71ca035c193a786f3bbe4d9a72c9918e100c20833a4148835c9"
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