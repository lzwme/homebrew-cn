class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.5",
      revision: "b4975cc34573f13e5500f03e1c4434218451048e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bedf5f0860527489e8c6660d50818c9e7397d1c1dbc3a71ca524287800c7558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bedf5f0860527489e8c6660d50818c9e7397d1c1dbc3a71ca524287800c7558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bedf5f0860527489e8c6660d50818c9e7397d1c1dbc3a71ca524287800c7558"
    sha256 cellar: :any_skip_relocation, sonoma:        "509807e7fc4142a199e3ef86c01939a13cac6dd9505c19a908940101f382ef9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a87c8547d8bb2a54f2ecd06df37de74e23b62bdb20084702ae6ae83db9b3aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7157312a409d8898756aaf6d98f4322fa4fbb6d19f9e36b645965a4173ca495d"
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