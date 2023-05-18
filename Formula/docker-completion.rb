class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.0",
      revision: "98fdcd769bcd137f7538f898b37348f919536ea4"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, ventura:        "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, monterey:       "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb705f284c017aa02397da061a39f21c3f2f4c6cb5a59b091b8e5813b93b5092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0419d34aea40d0336ed0f831becfc2ef91ef5fe553ee9ef6a73ab0cc7a31b7d"
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