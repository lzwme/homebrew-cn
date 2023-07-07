class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.3",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, ventura:        "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, monterey:       "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, big_sur:        "38b331d82049b4967ce76df3eec063eb4d4e37d279ed850ed3cc2dc4934b930f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502f3761c5f06a537784ab260b519e9e92eb9f97f5243760dd250d4295b231b2"
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