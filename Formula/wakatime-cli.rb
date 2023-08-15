class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.74.1",
    revision: "b992cbb9476200a1e8e82828b3b87961bc6e7428"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc2d45571d0b31076943b88422404914fbb2e4289cf720775c325c69f7bdc7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450508ca0a6daa9f870fb22891d759ee17930bfd0951a36c6fa8846558d70fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd39b7100861cd73f2d2ff4e6d3ace86f5116d39a8ae34882e7a5e1da6b8705"
    sha256 cellar: :any_skip_relocation, ventura:        "7c8c612d6cbdf644c220ddce1737e42be32441cd401ce5e9d10048146c3a464a"
    sha256 cellar: :any_skip_relocation, monterey:       "661b7317c2ef6824e00559810a7e23c3191a3d3adc282c583452f4ca88092817"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc4aa42a1c12b6efae518cfca48ad7f2b60efa73e3f7a6abcfff1fa6d2b46813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de34ef7bcb727c1d00e0b3841521488d566be68f59452c2edf38b84e11ba46a2"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end