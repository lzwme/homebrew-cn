class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.11.tar.gz"
  sha256 "b17542cd78bf29cce903f64c2e9129425921357a34a2e9c0c17f32cdfdfafa75"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bae581573cc97bd7e16f319d553c049116e652bfdb04468d627321553a05bef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0cde3801f97ce3011839d3ee58c3c24ea8bf4b56731a79e7bfe14b0c0f9be05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152cde93e2e8e30d739de04609fae1cdd34146cacd555f0d81ebf38fef39d558"
    sha256 cellar: :any_skip_relocation, sonoma:         "270a8014b1cc7f60d5045d068369d336d1fa5c220a52480602d3bdc2f4e1d64f"
    sha256 cellar: :any_skip_relocation, ventura:        "285f42eb3b571b64b0d03478d72de6b4528b8ca5f13042e9af57b5d9061fa588"
    sha256 cellar: :any_skip_relocation, monterey:       "33561ae6ebab7c1ff9578a9312b82cd17d8a32644bf4c93cc3ca0a16514f80a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3994f8b580302e44023113cf828c2b04ef31add6c0cedb3babf16b3b8c9b9b"
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