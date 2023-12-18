class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.86.5",
    revision: "545165f3efeb60026ba02efb21e0f6c13c5fdc4e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44155b9c82bc688623433806507c28bb6bc5438e4ff55746d8900c6c484f6326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "128a6003c2ab486d87027c43bd79b55d5ed2ab6067ade44174ba8b450a8fe769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93164b16739ae05041e679a5df56c256ab358417cb1eb83810702fb6cef2e66a"
    sha256 cellar: :any_skip_relocation, sonoma:         "13d7e4e8662e2d577c6788cc452e60e6c2cd5c91caad65b15c16b88176034dc9"
    sha256 cellar: :any_skip_relocation, ventura:        "f37975a04edbe23ccc1c0451125483ebb547df26eb2482652c26fc7e6533cfb8"
    sha256 cellar: :any_skip_relocation, monterey:       "723acb54d06ee41539b51ee1b2a53ac70fba57a8a5922c5b774590ddb43ea7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cade5a820ea238dfcb695dd0756fc5e5ca0d3ae9182fe2123c0daffeef1fac4"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end