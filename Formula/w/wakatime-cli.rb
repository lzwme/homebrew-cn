class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.24.0",
      revision: "fff16f70601fdc984da56683a23fa968716a5ccf"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acc47fc0b1943f70a5b1f84be9d7022f3ea138f4571b95617c27b31824d93be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc47fc0b1943f70a5b1f84be9d7022f3ea138f4571b95617c27b31824d93be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc47fc0b1943f70a5b1f84be9d7022f3ea138f4571b95617c27b31824d93be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5808289a3dd6ca8d6564b214d2e33b4b895541a6bdcd1fa1e417aa17fb8b5bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b4cb5c7324a61b9c7b518e5d504039bc20fffc9eba2dd0925b77b9d4218d8c6"
    sha256 cellar: :any,                 x86_64_linux:  "50badd5a87d2b6560d239e454cec1687d9b18ffbb5cbfb934414e5daa33f4f69"
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