class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.107.0",
      revision: "80e53d7e31150569e9faf6b3a60b461ecaaac0f9"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "468e75e2ab8d7f6621b3718310d46146eabd48d0034a85b422c9e8d345076eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "468e75e2ab8d7f6621b3718310d46146eabd48d0034a85b422c9e8d345076eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "468e75e2ab8d7f6621b3718310d46146eabd48d0034a85b422c9e8d345076eff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd943bf0834a24c2c2a7439a28f41aa0335a1abdd61f062c6af0fd446a0f3aa3"
    sha256 cellar: :any_skip_relocation, ventura:       "cd943bf0834a24c2c2a7439a28f41aa0335a1abdd61f062c6af0fd446a0f3aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aac8e4546a84f2d11ab52eedeaa800bb5717f064cc61bf991660cdf7ffb67f5"
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