class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.115.5",
      revision: "d091948eda7c7e32f563f2056348f992e3584517"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c1161e167ffc591b2d8514c94d954d3766cd3b5a46c88911ff3628edf4fa05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c1161e167ffc591b2d8514c94d954d3766cd3b5a46c88911ff3628edf4fa05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9c1161e167ffc591b2d8514c94d954d3766cd3b5a46c88911ff3628edf4fa05"
    sha256 cellar: :any_skip_relocation, sonoma:        "38fe938762a5b947aa2d738e57f886a88cc1ae827c7e9b1e47d00d3155afdca4"
    sha256 cellar: :any_skip_relocation, ventura:       "38fe938762a5b947aa2d738e57f886a88cc1ae827c7e9b1e47d00d3155afdca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5ca926ebf970350d91ac1abd8708981100af57b3935de6f31efb7fdc0b7e80"
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