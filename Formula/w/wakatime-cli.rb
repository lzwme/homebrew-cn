class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.21.3",
      revision: "fb588a6a475bc887e4fc4a2748a11a0bb25b15c0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "893e8f85dac684a906f5a8f8880c0c5fe7cf9265bf7c1362dc8c79edd2da4487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893e8f85dac684a906f5a8f8880c0c5fe7cf9265bf7c1362dc8c79edd2da4487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893e8f85dac684a906f5a8f8880c0c5fe7cf9265bf7c1362dc8c79edd2da4487"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee912793487c2222489827c26df77bee5ba053e801725c1a9505f96a84e44b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084c68c85b223b12bc1db284e7beee8d9c09334f7e32bd11cd69c48cef7f96d5"
    sha256 cellar: :any,                 x86_64_linux:  "9c5ea62fd4048248c9b9e160facf4e5a17add2b41e869205a1019e598f7c5e85"
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