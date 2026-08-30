class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.0",
      revision: "2c50d2df62302951d107c669a811f35fb8af1e91"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71227a9753c1f121bd0eadba35fa367fc6ae20f2dbad6bf6ca6f855e6b1f17d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71227a9753c1f121bd0eadba35fa367fc6ae20f2dbad6bf6ca6f855e6b1f17d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71227a9753c1f121bd0eadba35fa367fc6ae20f2dbad6bf6ca6f855e6b1f17d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d963ff055c13889b87570599083fb1149eab978207d76df159651dea62fe1d"
    sha256 cellar: :any,                 x86_64_linux:  "b5fc7c69fd263bcd0a81fb739c5ed35764ecbc063cc10e526c45e5ff8734a9d4"
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