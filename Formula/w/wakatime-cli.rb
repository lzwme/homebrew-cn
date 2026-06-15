class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.16.1",
      revision: "1f78603fd52fb9f7ec8670241bfb607fd2b5b946"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ba00670c904db6c22a0c856142a47c0c9f5bd82037faa1556efc19f5745e36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ba00670c904db6c22a0c856142a47c0c9f5bd82037faa1556efc19f5745e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ba00670c904db6c22a0c856142a47c0c9f5bd82037faa1556efc19f5745e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "93d4118f096601e749eaa337755c3615a9e44e892f87ebec954856f9baf39511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d654d05625fb75fe298d05898e223f850c8c35eedcc436db1274ebbae1e593"
    sha256 cellar: :any,                 x86_64_linux:  "a17faf7ef82d8171f15d5b9c234d5f23a016625a41d2ca166e7bd0d75683b12e"
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