class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.102.4",
    revision: "fad2841e90a2809a592a77dd3d46c03392f05f9a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89ef6005477fe8dada505d8b654e9b3e2dc8b9ebbd86c8c938b125d3753686b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89ef6005477fe8dada505d8b654e9b3e2dc8b9ebbd86c8c938b125d3753686b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a89ef6005477fe8dada505d8b654e9b3e2dc8b9ebbd86c8c938b125d3753686b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea7315a0ad7af88b0b85f123dcc2e78b3c5c69ea957873704222c2d709da587"
    sha256 cellar: :any_skip_relocation, ventura:       "9ea7315a0ad7af88b0b85f123dcc2e78b3c5c69ea957873704222c2d709da587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0176dc45ed856d7c7c02b63ba136902e002db9ad043571b5e7135da8d5d7831"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.comwakatimewakatime-clipkgversion.Arch=#{arch}
      -X github.comwakatimewakatime-clipkgversion.BuildDate=#{time.iso8601}
      -X github.comwakatimewakatime-clipkgversion.Commit=#{Utils.git_head(length: 7)}
      -X github.comwakatimewakatime-clipkgversion.OS=#{OS.kernel_name.downcase}
      -X github.comwakatimewakatime-clipkgversion.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end