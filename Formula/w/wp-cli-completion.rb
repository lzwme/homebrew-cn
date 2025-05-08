class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https:github.comwp-cliwp-cli"
  url "https:github.comwp-cliwp-cliarchiverefstagsv2.12.0.tar.gz"
  sha256 "5edf426895cad99c7fd6486de6618e7360ebcdbdda0684b78d587d67b4749345"
  license "MIT"
  head "https:github.comwp-cliwp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "157dc6d8f92431bf3084c0ce8b8f78149299ad308b17ca23df5235622213565c"
  end

  def install
    bash_completion.install "utilswp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}wp && complete -p wp'")
  end
end