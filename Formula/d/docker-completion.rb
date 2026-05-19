class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://ghfast.top/https://github.com/docker/cli/archive/refs/tags/v29.5.1.tar.gz"
  sha256 "de3cdd74a66f4cfe843983e4ca8d2133cf5eecc8ad8b5450cec0b7ccd59f921d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f7c4f61c5cab06b8b02be75b7f18ae4ad15b6a4d3ed2efb21795780b2fffd50"
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