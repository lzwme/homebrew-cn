class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.130.3",
      revision: "1b610ef088811ad64dbd38878dfa8ca0b837ddfe"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fd262f45a9404fad46d3588f59356713721c8d1dce7b37c13256c11044e963b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd262f45a9404fad46d3588f59356713721c8d1dce7b37c13256c11044e963b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fd262f45a9404fad46d3588f59356713721c8d1dce7b37c13256c11044e963b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6141edfc8e1a64b24e6fc43a5ee0d4c46fa108232f4bc99c7b397af72e64ab1"
    sha256 cellar: :any_skip_relocation, ventura:       "d6141edfc8e1a64b24e6fc43a5ee0d4c46fa108232f4bc99c7b397af72e64ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efcaaa88ae494046c54a066989a6d96e27926eab3daa2cbb09ef81f9a4ce382"
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
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end