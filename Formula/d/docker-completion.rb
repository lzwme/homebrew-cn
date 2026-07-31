class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://ghfast.top/https://github.com/docker/cli/archive/refs/tags/v29.7.0.tar.gz"
  sha256 "dabee4ef9d2906e2f1e3c5879f9ee43b38a3449f1017aefd940931ccede0bec7"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "736e3a26662e188c681005455daea8b026425a1c81d9869c6936a32e0d8a9cfe"
  end

  deprecate! date: "2026-05-31", because: :deprecated_upstream, replacement_formula: "docker"
  disable! date: "2027-05-31", because: :deprecated_upstream, replacement_formula: "docker"

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