class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.88.1",
    revision: "d6e80830213d6f330fb48dd52ab48ee4c4e89e15"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "313383ea83b69c14382f819d9bb994580a63471f499dcb7493f6cc60c17779dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46b20b37912fc4a9753f52d120f3f17e4ac2abc26252cc91bacb19531eed33ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5afefa64885302db5bdf77b0bc6a77d0fb05a05f0c50eaa1ce2236e608e3c631"
    sha256 cellar: :any_skip_relocation, sonoma:         "f973930a3b1e2cfe799c30510f996ed1b0841fef8e6794331f9267e0656e2ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "bdc0e716a03469ce78fda9acffeb73fa6ad46e515834d4ea9a8a7dfacb373793"
    sha256 cellar: :any_skip_relocation, monterey:       "6051c8cecb6e4cfe1ba10fc5621afab4831f0fc4209f5f20b881ebf1badecdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f5d958cd1cd5b26c40479933df0163a36f11daad5a5e61807d9b22dd9db560"
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