class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.5",
      revision: "bc4487a59ea927322d96a0a0876dd6047f82e72d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, ventura:        "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, monterey:       "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, big_sur:        "7edea182680b46eb08e733473ab07f274240328ab17bfa56301da0486466aa00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf03b7de7da225f4422928a2a886897e1ef570f449fa587845b4e5c3e889e498"
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