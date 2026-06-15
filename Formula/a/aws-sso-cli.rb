class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://ghfast.top/https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "e8999b3db5ee6f90f27f44fc5dd4c19a3365d6a9d57a59ac167537963b07484c"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786f8ccf3a1ee4f3288a2c8154dc8e3a10cba86364c833cc27aa2a1e69425b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2775fe173c6da56cd5da255e16850c4ea5339cd80cac968a7b02cc44309b83e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b03784e7a64962e3e526bc3df1999f91c067096e49df59a1b2e241d132dc6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ee3bc04fe5507cd0d2b77511758d3bacb4d3558ffe7af7da85ffe8e2608cbf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a71fb38f30b6e762241d85ad9ce09246cc25c26b4466f712dbf85a95ea639b"
    sha256 cellar: :any,                 x86_64_linux:  "cf93f9ef86ab35474fb33a1a6f6c0f8ad19c802855d6d46bbf205b6d9e54a599"
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