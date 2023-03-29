class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.2",
      revision: "569dd73db13099a7c3104d73aa15117b359045bc"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, ventura:        "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, monterey:       "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, big_sur:        "39ed4c22994edfc603c88347c44ee4ab23809a1247bd462290668b9f99ced84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b15275027bb82a8d6cb2c6d3790aa2916b5623df2518888937aa4cb0ee4c6d8"
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