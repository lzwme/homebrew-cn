class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.5",
      revision: "65bfbdc29d67299d6b4796325871c240531d84d8"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5a6c7998d6462995bdb4c45c1e90f3b3ddabdee02710174ec9095770c066e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5a6c7998d6462995bdb4c45c1e90f3b3ddabdee02710174ec9095770c066e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5a6c7998d6462995bdb4c45c1e90f3b3ddabdee02710174ec9095770c066e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "86554c50be80799d0b0fa13cfce62280c5aa86d043c92e41381559ffde170bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c613e5addbe7fa0835b2ca15186e36dc36d8c62ceab204749aa2982396e69400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73528e8dee2a35e7b1dfd1822ed242bbfe83bb4f4bbef383e469f32c8657e37d"
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