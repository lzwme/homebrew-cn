class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://ghfast.top/https://github.com/docker/cli/archive/refs/tags/v28.3.3.tar.gz"
  sha256 "172dca437abb36485275a8d43550db90b6878bcc676fc0b73a67a57a15026cff"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfac0b82af84f781b73c2e407de67672a5a3f5ae1a4f1cccc079e01cedfc40d4"
  end

  conflicts_with cask: "docker-desktop"

  # These used to also be provided by the `docker` formula.
  link_overwrite "etc/bash_completion.d/docker"
  link_overwrite "share/fish/vendor_completions.d/docker.fish"
  link_overwrite "share/zsh/site-functions/_docker"

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