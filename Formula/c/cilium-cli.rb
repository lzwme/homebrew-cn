class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https:cilium.io"
  url "https:github.comciliumcilium-cliarchiverefstagsv0.18.4.tar.gz"
  sha256 "733764d4b519bd94144f1e2398583d06ae91ae5e7ad260cacf1ef9c3d914c3e8"
  license "Apache-2.0"
  head "https:github.comciliumcilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22b7c84283a27ef306bb65b0583c4a49f267ba1cd5fd5533ef3e036dd7649ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff420edf8bc142753fbf8e20cdab91082d80e4950033a4202ec41cbb25c74dc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fb6a8e785e744f1be8f1370de46e701fbe467df53bd6c801cd11b9d81552f38"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9ef4bbf7d1e91a3352a059c1cb87deb26bc48ee5acd170d12c1e33c7201563"
    sha256 cellar: :any_skip_relocation, ventura:       "fb0685543e6ed33e802d187ea2030f3c4cbf4daf1e3547187e898c0cae69edfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8eedb8abf7757cc72db9cb263f650a62f953d480a8c4b4936c8d7dcf272574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be981c25a2da7f03750fa0c2ffa9d4001083fa2b9f69e4a980d6e479fe136d68"
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