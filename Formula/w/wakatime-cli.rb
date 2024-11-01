class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.102.5",
    revision: "04fb85a6f8050a61d2c656c06ccb63069668c14c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca6dcd6de39b898505d3fe169887c42187a023034022a253bd0ea77ec2d3f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca6dcd6de39b898505d3fe169887c42187a023034022a253bd0ea77ec2d3f2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ca6dcd6de39b898505d3fe169887c42187a023034022a253bd0ea77ec2d3f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba722baf5edc573c194923a967accc3f436ba9153f4ce75e63c90d566ff9adf"
    sha256 cellar: :any_skip_relocation, ventura:       "0ba722baf5edc573c194923a967accc3f436ba9153f4ce75e63c90d566ff9adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd3eba35d9f224436d759225f3fb855d281a0257603f462e4c5c57eb0373d40"
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