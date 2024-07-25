class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.98.1",
    revision: "72aa4f33c44eac248fcf062ed97555bc68a8fbd8"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7d0c18a0a019dc9ea7874922f3429f34ebc7d1018820d59cd1190ab07194309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15250b8a95349404bf7bef2fd9566d43c74f33e5afaf203f771926cb77c9e3ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e78624d56dbc91fea67af9a05c31d7f6c4c24a4621de78278526510a9677d3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0768e447bc947e5322ae0a32cca1a063219b348c97ab6cebfc5ca2cfc95b09ec"
    sha256 cellar: :any_skip_relocation, ventura:        "322e19dd8679316d8743ac2cf04ae5d4435ed6a23eb48f4deeda91e72a584058"
    sha256 cellar: :any_skip_relocation, monterey:       "63df81e6103958c9110a15a364ae4c5f5399e4cb0d41ccd8df67022ff74f064b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c067f58a1e8bf175dd4b2e131255c840ec3e13b934e8eb478db423419e6b9be9"
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