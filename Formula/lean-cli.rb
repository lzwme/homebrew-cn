class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://ghproxy.com/https://github.com/leancloud/lean-cli/archive/v1.2.1.tar.gz"
  sha256 "9f0355d0ae4c07f3ca4cfa6639f30c43c9a7c7a455473f047d0227477d7b64b1"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "468f1f7d6e8e758d13a64fae1b6fc0ca259e2ec442ebf6926eb89712cdfa0bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "468f1f7d6e8e758d13a64fae1b6fc0ca259e2ec442ebf6926eb89712cdfa0bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "468f1f7d6e8e758d13a64fae1b6fc0ca259e2ec442ebf6926eb89712cdfa0bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "280869189a813d7296521cfbc377f76caffac7a1c3b29fed3b3eafbdd950b279"
    sha256 cellar: :any_skip_relocation, monterey:       "280869189a813d7296521cfbc377f76caffac7a1c3b29fed3b3eafbdd950b279"
    sha256 cellar: :any_skip_relocation, big_sur:        "280869189a813d7296521cfbc377f76caffac7a1c3b29fed3b3eafbdd950b279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd443ac038178aefb7066df5543aa8979c84a2179b9f1edc9f64dbbfdcf3a92d"
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