class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.14.tar.gz"
  sha256 "c3e2ac5597d3ba53ad828e752fb131ad2fa066f752edcdb9682dfcacd72becfc"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cdbc44e6b40c1a36eb2f5b75a2e52df68de2511ec20e970c4c6af8608603b53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9401796b06d2ca85cee23230b144b7d2f4e332b24efbaf7eb6432dfc43bd09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a61bea053bff27f061b4cc24ecec823916ef65b6e0c209449538b9a96e4b165"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f496e5cddfc8c0411648977f1f794b2f3dfcae09ee7e51dc260b23bcce9413"
    sha256 cellar: :any_skip_relocation, ventura:        "40be8fd760ad5fcbe1995671d1068db707197d45c8b30b3947e7eaa32ac1472f"
    sha256 cellar: :any_skip_relocation, monterey:       "614b29c20b2cd572d96bf60c6be0d0626c8ffeab2b8c62ef476d3a49dae59cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1faf933d997dc1f8c6290e514cc6eeb2dc4e601698245ace20f8e8cdf3e6624e"
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