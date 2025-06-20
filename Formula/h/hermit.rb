class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https:cashapp.github.iohermit"
  url "https:github.comcashapphermitarchiverefstagsv0.44.9.tar.gz"
  sha256 "d7b04dc42286a77baf990254e853c00575bea9a8cd8982a9bbd96ec6295f008d"
  license "Apache-2.0"
  head "https:github.comcashapphermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7365e30853d588eb1a14d45f7ea46303dc1739d66402f5efe43958fb64e9c81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b40617432e4d10498f4dc6d2b037b40e690de624c9dab18760e8a0324db3c512"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79d6e2b4e7cb775dbe85292215e955a3312daf803b93f37923257a4662e63eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f48985100c34f511728513689b2ef8a3e0beec5e13e2e22064ddd45f3778e53"
    sha256 cellar: :any_skip_relocation, ventura:       "16f9cfcfe5dd6203b9593e3e72e7c5adcb919d52cc483f55bfdfbf44a5e49150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "058095239d7aa8af10e5a907456785a7c86baeedd4332c3141bacea4bb537014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01051ae0b63bdc40585e1e4ca527f7c1a906563f1498bd524eb5dfb7d40e52e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)binhermit && $(brew --prefix)binhermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)binhermit && $(brew --prefix)binhermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hermit version")
    system bin"hermit", "init", "."
    assert_path_exists testpath"binhermit.hcl"
  end
end