class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.8",
      revision: "78614b9a57654b25a24ad3b1fd0d53989bc50375"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee317baaf3e29c136a5b7b729f1d49e67f58579ba377fdc397d3256e88448da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee317baaf3e29c136a5b7b729f1d49e67f58579ba377fdc397d3256e88448da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dee317baaf3e29c136a5b7b729f1d49e67f58579ba377fdc397d3256e88448da"
    sha256 cellar: :any_skip_relocation, sonoma:        "249c8c4c634c170c0240097a1cad9283589341d308272c15be88dd3f597c626b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa03214f42529fedd7710e7044af9190a6564f7c0cf581d7fa360a7cf7dea0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bebb0711dec59a508c3dababd72881e1a37268d01a726108760adb35f8d64557"
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