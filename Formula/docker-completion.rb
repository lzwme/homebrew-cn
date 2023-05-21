class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.1",
      revision: "680212238b47d4299b62ed55e3113a498cde3cef"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, ventura:        "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1e8b5d725d8f1c7cd01d97b75da77fb327f2cf50a0ee7cf0038667029ca0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843c725fcbd70a9436ba273f9152abacbc74fb58d47baa90c4d9f5fbb920fde9"
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