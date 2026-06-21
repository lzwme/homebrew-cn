class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.20.5",
      revision: "6865e1b694c3bb7cbf6514003e7de661cc1a5e45"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e196453b7e6b60fd889e3afa2f46133781aacf5b4355a473125097eff854b363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e196453b7e6b60fd889e3afa2f46133781aacf5b4355a473125097eff854b363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e196453b7e6b60fd889e3afa2f46133781aacf5b4355a473125097eff854b363"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7deb1ed7c805066bec4be1cabd958b2c1e4102dfd20896fe89c886d39cc5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ef0a11cf8230bcd0acd3ea6bd234718ffb3eeef3eb21a2d9b5900376a140a5"
    sha256 cellar: :any,                 x86_64_linux:  "b8646340adc4d46e621a5ca86bc8003611fede8570f90dbc430e268ddd642340"
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