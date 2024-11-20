class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.105.0",
    revision: "22de0929894d9785a02c28eaa9dace39dc1b658a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02bc5542f5fa204dea0ec2ba29d9a74379d19dc80250cf0f12ba89a0aaa2384c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02bc5542f5fa204dea0ec2ba29d9a74379d19dc80250cf0f12ba89a0aaa2384c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02bc5542f5fa204dea0ec2ba29d9a74379d19dc80250cf0f12ba89a0aaa2384c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ff45cb89926def8164c484b50566179e3e5b23232e7f7e97263b82b066070b"
    sha256 cellar: :any_skip_relocation, ventura:       "e6ff45cb89926def8164c484b50566179e3e5b23232e7f7e97263b82b066070b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0aa35ad3ecc5c3c82f340ded730aeb2528fb6be5263ad94e05c12cbb1e1a7b0"
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