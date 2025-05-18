class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https:synfinatic.github.ioaws-sso-cli"
  url "https:github.comsynfinaticaws-sso-cliarchiverefstagsv2.0.1.tar.gz"
  sha256 "75664d0b771ff7d0428e3a85f7511faeece50fd91dc9c603c04a0c72f769f9ca"
  license "GPL-3.0-only"
  head "https:github.comsynfinaticaws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70dbc95002f3eb447dc808bcaf1bff8e5b57b757cb667927ee71ad6b96bb37ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f408c439ede071a8ba98952988e7a764ef07bf1531385bdfce6bb86f7c14084"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9f556577cec3effe49199d7b2e87e3738602de16791fdbd3edda5cc32327096"
    sha256 cellar: :any_skip_relocation, sonoma:        "273f67eb47252b0ba7fa872d7bc1777537fc526ef6caa5b66612858f97f789d7"
    sha256 cellar: :any_skip_relocation, ventura:       "4bced57d60590b13d55e733bd33c1b938910672754a948e80d97e175b1aab2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6edda5f9fa9fc5bd1273f5d8df43d7ace6619f5f9223f216d0dc326abdc8abdf"
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
    system "go", "build", *std_go_args(ldflags:, output: bin"aws-sso"), ".cmdaws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}aws-sso --config devnull 2>&1", 1)
  end
end