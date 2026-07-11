class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.22.0",
      revision: "5286fc2ab9d638c7a8f1b6cf2314bdaffd827715"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "053c48f343eaf9b1f4a3389bb84c8ef875cc3473756d44c0b4200fec55198b95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "053c48f343eaf9b1f4a3389bb84c8ef875cc3473756d44c0b4200fec55198b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "053c48f343eaf9b1f4a3389bb84c8ef875cc3473756d44c0b4200fec55198b95"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e5eb849b93122cc419735b0b53eea40cb2ba7cd068c2461393e82524c97102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e01b31eba562a8e9284e970dddece07d0ba2ec8d705b03912ac29941e2a1402"
    sha256 cellar: :any,                 x86_64_linux:  "7ebc2a97d3252f151446ae71af2eede3f8f04a2aea2ebeaeb13f88f95dc7fe60"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end