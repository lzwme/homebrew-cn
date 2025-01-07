class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.110.0",
      revision: "1edc4574cecf830c84be95e8abe1fab51b863262"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a4493fd20d5886c498ec74e19f3c2b721bb6b352a4d583ef752a185d9f0804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a4493fd20d5886c498ec74e19f3c2b721bb6b352a4d583ef752a185d9f0804"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7a4493fd20d5886c498ec74e19f3c2b721bb6b352a4d583ef752a185d9f0804"
    sha256 cellar: :any_skip_relocation, sonoma:        "75870628ec7e909da0a459e49dd9134180b8861e2ec6bfdc96510ef56a5b031c"
    sha256 cellar: :any_skip_relocation, ventura:       "75870628ec7e909da0a459e49dd9134180b8861e2ec6bfdc96510ef56a5b031c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2394a0c2dd8bc8ab3bbbca38e75557cffe13365ed964670a169fc83fce51fe9"
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