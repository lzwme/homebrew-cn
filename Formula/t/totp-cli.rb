class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/v1.8.2.tar.gz"
  sha256 "7e53e012509d33ead6a97e8a80ef055525a90c506882317476d95f2139e90038"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd475f80853b5e9cbcfc10eff44d5439ab6081819c1a90c68b462648b08eb2bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd475f80853b5e9cbcfc10eff44d5439ab6081819c1a90c68b462648b08eb2bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd475f80853b5e9cbcfc10eff44d5439ab6081819c1a90c68b462648b08eb2bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7161c15595c614c77420e6cec4de88a8abfe6d7ae1fc064a4d61a36538ec0886"
    sha256 cellar: :any_skip_relocation, ventura:        "7161c15595c614c77420e6cec4de88a8abfe6d7ae1fc064a4d61a36538ec0886"
    sha256 cellar: :any_skip_relocation, monterey:       "7161c15595c614c77420e6cec4de88a8abfe6d7ae1fc064a4d61a36538ec0886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627835533372bccb70287d6d956ad748a266ad0f329e86cb897ae46324410ae6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end