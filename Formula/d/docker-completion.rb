class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v25.0.4",
      revision: "1a576c50a9a33dd7ab2bcd78db1982cb965812b0"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c57dae8c9386a00b6ad63d04cb5a1a7d0a231ec693997bb6ac2d72df401a7945"
  end

  # These used to also be provided by the `docker` formula.
  link_overwrite "etcbash_completion.ddocker"
  link_overwrite "sharefishvendor_completions.ddocker.fish"
  link_overwrite "sharezshsite-functions_docker"

  def install
    bash_completion.install "contribcompletionbashdocker"
    fish_completion.install "contribcompletionfishdocker.fish"
    zsh_completion.install "contribcompletionzsh_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}docker && complete -p docker'")
  end
end