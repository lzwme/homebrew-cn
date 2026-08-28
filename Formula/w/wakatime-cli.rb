class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.25.0",
      revision: "bc92faaaa3a6769ca4884b16bd70d594d47c63b6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b022a2cf3efba993bdcd51077e07fe4386a2eff8ee854ac0338043492701f9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b022a2cf3efba993bdcd51077e07fe4386a2eff8ee854ac0338043492701f9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b022a2cf3efba993bdcd51077e07fe4386a2eff8ee854ac0338043492701f9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6952d514e538ef7c9cb56b4bd74c9ce2ef04b93d5c1b43022ca15455d4b3476"
    sha256 cellar: :any,                 x86_64_linux:  "e0a5b776c7563b070754f5c751a80ba6aeabf29f9eaf07f7fd4978ee52aec82e"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end