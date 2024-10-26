class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.102.3",
    revision: "75e174922bc3379603762cc41b5c09a2f05ecd55"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f755c0e5245ec9e32a82d9e79e835e62844fa7418a0e13b17d8e72e779ce5bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f755c0e5245ec9e32a82d9e79e835e62844fa7418a0e13b17d8e72e779ce5bb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f755c0e5245ec9e32a82d9e79e835e62844fa7418a0e13b17d8e72e779ce5bb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab5c94458e91f49d7a1181a9837f7818c4712f811e194292cf244660be74bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "cab5c94458e91f49d7a1181a9837f7818c4712f811e194292cf244660be74bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a769f33990f09ed2b3a5790c070395018dc6f08391c75bffb940d985b865894"
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