class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.104.0",
    revision: "47a30d3d9a60f6cbc4f2bf9ff56270fef326460d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47296584ee372f399acbb8f1229dbe1865d84d36cdb867f3e664a3333684193d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47296584ee372f399acbb8f1229dbe1865d84d36cdb867f3e664a3333684193d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47296584ee372f399acbb8f1229dbe1865d84d36cdb867f3e664a3333684193d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4fa1e3cad05e2fd0ae00ec1516af456ee5fead45cb6afa94457d99e26a67a5a"
    sha256 cellar: :any_skip_relocation, ventura:       "a4fa1e3cad05e2fd0ae00ec1516af456ee5fead45cb6afa94457d99e26a67a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee9d27e8fc5c7551cfe6bd4fc6a3e4698ce69434ac2b806931730e402cf66ff"
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