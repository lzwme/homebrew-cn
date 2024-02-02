class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v25.0.2",
      revision: "29cf62922279a56e122dc132eb84fe98f61d5950"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "251922be53fecdb926b7ce66165d3552d2bfcd43d65dc6d9a388d0c36edeaf69"
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