class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.5.tar.gz"
  sha256 "ba2c7d040f6153fdee587b8322e9592bfe3eed37212c68f90956791664e16b82"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02bab99f977a0c2f3a325cd5493f32d77188b48a57f244745611b87808798c24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1330752788f620088d40bf625d00402718c7aff35140eeab3f72fb906c01edfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1676d3d0c1a8ebb87124607032146d132ede0772022ebde9e9880e324667079e"
    sha256 cellar: :any_skip_relocation, sonoma:         "73dcc194f8d390fd221f73f7c2e629f5f49f572330074046be5c478a8d4b4613"
    sha256 cellar: :any_skip_relocation, ventura:        "88f10ae4aaf7967177eb0a18b9e10dc6caa97fc08673abf8ad7a7f39d9da512d"
    sha256 cellar: :any_skip_relocation, monterey:       "a27aeeff53958797cc0ce7799945daf2693c872aa349c207699a1d5e6195b208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8649bf621fd6ed9464ad47c5438a447d1bc6dfc400baecf2c7d2a83e1210177a"
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