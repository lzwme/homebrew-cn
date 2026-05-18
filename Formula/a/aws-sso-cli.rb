class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://ghfast.top/https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "b0ee905b33afd5f12feb73490fec1f5dd1181b2a6d69f049a9396e5afb3b1e1c"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "608c3c346d683dd13e326dff50f9e6ee1371bac2f7facc13af426703e436b154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e62946617f6f2c5749c0050aade46ae47578cb4926ee641596835cd74a7dfec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77cfc8219ffef1622df0e8aa041d23b2c55db1807ad0f2be2e4e6b9cb4cd873"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6be3e48e75c6d1874abc23bb82ba59a4b3348dc3202a383688cd6145390d669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebc5dd064be78c765d42a37dc01e012e7289cd3eda7b881340feb9f9244687d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b84b6f5b6adcd976580f7938441182f59e3e4325af5e3995348bc44d0e9917"
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