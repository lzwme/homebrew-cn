class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://ghfast.top/https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6a9757671aae65dccdf268b4e420b2f5060b1acaa9764cd6abf6df11ffaa5eef"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b718f774bb24fec1f0342654f9dc2a0f747ecd47dcaad15b55a8f304e77d208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "792c791e8b13378fb2f754e0cd5bfc85ab23a3d23dd41882a4d06af4dbe28f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88a566893f77a99687ce3947b71ce3560814a6fb218e2c217b2d0898fa031cb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "893dae885f24e4979737e1a6bf447cb9774ee360d8bbd377018e68cc9dedf8f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0962a298d73be5c72b22ff3ad6625c3c5bbe4e22dc8a0ce1dad113fd6c68a05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8094b146bc63bd0161d1062b9f2bcee9e7c6473ef120e044466f21b54397e76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"

    generate_completions_from_executable(bin/"aws-sso", "setup", "completions", "--source",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end