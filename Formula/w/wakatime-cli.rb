class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.95.0",
    revision: "b52f968da990400f16b9a925756222201a69a76c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55a063a315a5c30eb464ef6e52f906725c80d978e9d8804466ad7b2863fbd05b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67af92ce5b0230183e40a4c46a8c1435b4d0fbd4633bd60fcf14d3deaf1ea1ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1fb47e0eb45dc21fbd5ec4606601be9ed612975a821930bbb01484773b9363"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bd9c7a69a380898ab7f56fcfd5fe9a4f17867b5ce050b310c122b0e4a8fbb6f"
    sha256 cellar: :any_skip_relocation, ventura:        "7235aebcff2b7400826ac2cc2dea438d446645f26b84ed305661d1eb6e7a9b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "e5dd321d595c57817bd8b6ad204d608d2b56dcc7cad0710e4436d1ba1f7ffee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47bc375e5bc9a34e1285a3018daf07f1c2c18afcd960cc6e3c66637f5437972"
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