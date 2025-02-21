class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.17.0.tar.gz"
  sha256 "b1805b88d0b4582c669123f46e0e92e157e03f07dff7bbfdad867648ba6dff94"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f202348621ce17942349ab9783a7edc01c8446cb236288e2703124e6777fcffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47642159509b7211feae0dc690aef9ef8e59bf7d48f8a10314859954df6ad00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfdbc9044b8ea22e95bcd3ab017679cfe7b803511e6933a39256114f3395fdb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7ed5a266be8e89d294f9a83b6775f515366545586bcb7d388b93151369dc1dd"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8a9aa8511c02a65da218e7b374a2524624715f1736dc8f7f41a1527d00b0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf9803ba1e899d8f36054a6c9c3e19974e41f8f53071f50d890761ed8762650"
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