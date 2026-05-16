class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.0",
      revision: "7c1b678a01f3365fce266de72fcdb5493f7e5d54"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a5f2a33785dd6e54c39995fcec25c52fea7876ff6bfc676e31aa24f0708cb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a5f2a33785dd6e54c39995fcec25c52fea7876ff6bfc676e31aa24f0708cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a5f2a33785dd6e54c39995fcec25c52fea7876ff6bfc676e31aa24f0708cb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc78acea374c3a6a20f74c709655979f62bb2891d1dd4bf00050afb12911e5f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89b4acd6a4cfbca53d7a969504bc561cc4edf492462ff0547580de69588717f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e7b8a72ae0c4a5ba0769d26ba46df117b89307377a747008fb09a6c7bb2f96"
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