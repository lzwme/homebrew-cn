class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.106.1",
      revision: "b37839793d0b437502cc5536097c2379d63e6dcd"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0c82454b6b3b5cb137fe0ce7921482b14270b1fcaad111d5081fb8dee7b85c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d0c82454b6b3b5cb137fe0ce7921482b14270b1fcaad111d5081fb8dee7b85c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d0c82454b6b3b5cb137fe0ce7921482b14270b1fcaad111d5081fb8dee7b85c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fded0ce724965d4886de842ca98648a96bcdc0fe68f52abfa0302f03a718ea83"
    sha256 cellar: :any_skip_relocation, ventura:       "fded0ce724965d4886de842ca98648a96bcdc0fe68f52abfa0302f03a718ea83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47ddd4b083dd3344599ce1499ad0ce3782317e8603ebec1e44d118a41784a57"
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