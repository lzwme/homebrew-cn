class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.3",
      revision: "3e7cbfdee1eb5be2ac23ed3668c654362dcd29b5"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, ventura:        "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, monterey:       "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b513f9019b87aa4955f7fb4e19faf367ce546e4d851edc1a57508299d5900c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d8df1efe1bf9e7fae515be584da8ffc0235a07aaf422e6028ee5305f4d781c"
  end

  conflicts_with "docker",
    because: "docker already includes these completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end