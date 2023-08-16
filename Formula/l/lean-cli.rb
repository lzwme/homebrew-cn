class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://ghproxy.com/https://github.com/leancloud/lean-cli/archive/v1.2.4.tar.gz"
  sha256 "1d7c355b3060a35a8679e446cbe504423e09b55296c044a51a27a23c9298329b"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a358c0da0dd02839e235b9d2d4174be5bf5f9f397a0e2e8efddb4f958d95dbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a358c0da0dd02839e235b9d2d4174be5bf5f9f397a0e2e8efddb4f958d95dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a358c0da0dd02839e235b9d2d4174be5bf5f9f397a0e2e8efddb4f958d95dbd"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb771d51928d4ebdbdd14c689eabea88ec3bb726f4d63c86df37351cfe2b10b"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb771d51928d4ebdbdd14c689eabea88ec3bb726f4d63c86df37351cfe2b10b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eb771d51928d4ebdbdd14c689eabea88ec3bb726f4d63c86df37351cfe2b10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8df5522cc644bc6a8fe47738c5a27f58acdb143d7015bd5f7088b6b6422359b"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    output = shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
    assert_match "[ERROR] User doesn't sign in.", output
  end
end