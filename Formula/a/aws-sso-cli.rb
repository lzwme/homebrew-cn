class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://ghfast.top/https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "5e8607442d3f072f9362d6d34bc8f557ecb4839da71ef7f64c71dccbb996aa1d"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c4e080019e8e7d3683402255e5e127b7d63015a57a8207159ad942c17b6200b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1087eef29a8e4176621bacf11dc2eb351b7320e49f15a6e85965f4e4da86d197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aff3046bacfc93449c8fd2f02aa534ada48e7972e90f4c523fe943617d260726"
    sha256 cellar: :any,                 arm64_linux:       "403bc69bad1dc6a82be567b3642fdd371a1cb59681a928d8ff6f0cc6d21b5e32"
    sha256 cellar: :any,                 x86_64_linux:      "d0693ae7f6fcde130cb78681985b925010413986f0083b2fd5c7be278db92acb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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