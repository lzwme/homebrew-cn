class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.18.0",
      revision: "fe671d57ff9423e1c51b5198edee88030c5e4299"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77cc6a2712e68177356798c6199e3c5e488e101d8224d0826e31d3f27c7a44bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77cc6a2712e68177356798c6199e3c5e488e101d8224d0826e31d3f27c7a44bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77cc6a2712e68177356798c6199e3c5e488e101d8224d0826e31d3f27c7a44bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b2f8a268d884b1bc95561cda803277bbba25209cc191d9547b75fc3e0045532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d69cf86c269938b55c8c3d39d9c5ef6e9f75dcdb1ff480e8226b30b9d9e46f40"
    sha256 cellar: :any,                 x86_64_linux:  "fcc671fe7e00fccc82401b725f2065043873573bf774fcfc253e4e7c87619e84"
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