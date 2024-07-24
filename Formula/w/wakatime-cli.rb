class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.97.1",
    revision: "5d46cab280dd3653c47322bdaaeaedf2837e76a3"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "388addbc6ac98b35e32c3377c1c472b2951dbf53fe35018970f7da4f62031018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4654f6170f1d6a7cebac1d7f1c1ca81e0581b575a4a1fd28b70e1ae9f1b98c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "235edc0d5b970626a0e8f2296d8b65b7b7cf0526279aea27689ac981f58fd0fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ff3f253850ebb36b67c95b6ecece6ce03e340a3542b55d3f670df42586862e"
    sha256 cellar: :any_skip_relocation, ventura:        "8f22d53ad5e252b0dc6b8799548616efa2cd74d1083be4d9a8696b16806846ae"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4814790cab6e1ee5b2a275b3c90f37eacfb1ac058a1aedfc2b53316bde5383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d74646687e2007cd15214421d4405ba5dd80452cedb6f327f26680431f84703"
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