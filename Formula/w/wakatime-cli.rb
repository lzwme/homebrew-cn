class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.13.0",
      revision: "6af1428ec2aa4f811b68f9afec7a8744a1cfdc56"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff5495e503dc036e9236a8a7956cada074127ef1a084fcb3dddd0388494b0dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5495e503dc036e9236a8a7956cada074127ef1a084fcb3dddd0388494b0dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff5495e503dc036e9236a8a7956cada074127ef1a084fcb3dddd0388494b0dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3659e12ee6b68265ba248ab7bbf75ee9c54565c78cdec4c147320765bfe435e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0570fea21e11bd213b1e488ca0a592ef0320b447e89894a2ad97e89c25b2f872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61af3dff7b5608996e20d22f6a7c1d65e5aff55bd9e67a61944b754f2acb72b6"
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