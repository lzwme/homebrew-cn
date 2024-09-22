class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.16.18.tar.gz"
  sha256 "da5b95112b3351a8b54c2c3d90a5b1c1e4773eee027bf963708b9e44fa3505ea"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4700e3acff3f2631f2e5eb7d9705d371b689cacdd7b4c4da8ab5a7cfe666e6bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e167ba22ca502e4dd2f146458cceb656c09afea6c5b9889ac7d38812093c4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be5bbdaaa5145ba5cc4b09ceee8082669ae4b2de42d5875602b5e473e7b45ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa322c41ff1ba273be6b33f2097d5ba3993eef9c1384d9b530015deb0937b720"
    sha256 cellar: :any_skip_relocation, ventura:       "b2f916b20539d76c9b86fc3d590800f789e76228e2db10d0462553234bd393e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e8fcb4966e1f0e63dea5c5d1d1754d447171e23d788d3f3f9ed6d5b562ccbb"
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