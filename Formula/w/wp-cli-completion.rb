class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https:github.comwp-cliwp-cli"
  url "https:github.comwp-cliwp-cliarchiverefstagsv2.9.0.tar.gz"
  sha256 "442e70e4ab4e451b5316c178394fb2e54d1dbebabdc875be7c5a66965f370a12"
  license "MIT"
  head "https:github.comwp-cliwp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccef3ebf49d34fda8315bddc60033af9a1de8584a7827293233b488684887728"
  end

  def install
    bash_completion.install "utilswp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}wp && complete -p wp'")
  end
end