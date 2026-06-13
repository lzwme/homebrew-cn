class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.15.3",
      revision: "2aaa9c5583f47c0c7b1cdd0aaf8905c8d76d2fdd"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5983788f50999eddd02c3625da8b5e9834522f981fd8cb3875968921fb2704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5983788f50999eddd02c3625da8b5e9834522f981fd8cb3875968921fb2704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5983788f50999eddd02c3625da8b5e9834522f981fd8cb3875968921fb2704"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad33bdc0e56b20c29ca9f0e2f8f9c47ae6892eb925f567929f311846e69d890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4363811c6e1a6e3313f9a0c192bfffc0beaa24a407a779ad7f01acfa2d0daa47"
    sha256 cellar: :any,                 x86_64_linux:  "b567485231d4e40f17ad9c8ecd97d8c2ee19261939fd80841641b486296f5c91"
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