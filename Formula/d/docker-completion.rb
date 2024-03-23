class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v26.0.0",
      revision: "2ae903e86cab51f694c819721cdfdf5eec693720"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91b40e60757b58372bc79a8bb02869ff34af18386456094b99fde3bdab926f55"
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