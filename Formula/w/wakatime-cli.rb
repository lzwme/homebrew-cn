class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.85.1",
    revision: "fe403165d14babf3938839d70b20efb8af3ec6ae"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "959b625aea51a8718eca2ada91d01670c6e686561dfba49998389563f186dd03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d99701cadc50f81d3233844192a63af2b23b79dad1ce1382971fa01c0c4977bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26eba92580130b59d3e666f7b711543cb7aef823a9ef8c688dd2a449150a19c"
    sha256 cellar: :any_skip_relocation, sonoma:         "28126631632641e089ff886cfc1d39ebc7cd15499beae4ceb412ecbe549f4f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc53836e9b5893428933be0e7c433275b65439f0732a1aa93f12f1fe5774891"
    sha256 cellar: :any_skip_relocation, monterey:       "682f27fc43e8168f27e9f1161808030b15394c8e47649f8795509588ff73765c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d87dec43f4dd05824b1013a96f487c01b18c3c19ac659c53241cfeb1c453093"
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