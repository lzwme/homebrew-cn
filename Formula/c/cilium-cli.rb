class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.21.tar.gz"
  sha256 "50cbd5a8632d2255d288eaf1c1f56092a1978c9abd377a2017a98ddd815757e5"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e528c0835d1e263eed6ad72a759c590e0a859a99585ebbaed8068d931322a7e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1738d5d507d6253530ae33ec01df6425d74b417f7aba3c33254ac9b6234b4008"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c1093bd0cbb18f6d9f2e03840ad860b18d03055551ca66e7d495d5a0e3968f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dbb780d11dd3c7e45b0143ebc5c50c9a2d1e582e2ca63f752895fd345d6fc6c"
    sha256 cellar: :any_skip_relocation, ventura:       "37cb50daf4f46b85252cf39b21f717104028c2c91bc47d96430f8335873db379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2f414934077e358ee4d9a988e09a574953e5bd5f1db04b76607b5f8b23404a"
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