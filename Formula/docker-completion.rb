class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.4",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c3045a8ba9f07268bf28f723e2612a34acfefcb6a2d24cb2be4769f832895e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0bbb6a169fb6c51779930dd7fa725609155da8dd427ea1c0e7008fd2c132a2"
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