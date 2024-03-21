class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v25.0.5",
      revision: "5dc9bcc5b78ed23f12cdd68e4285ea1c216ce2a1"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eaa4568d438d4ea7e20bbd4d9dbf05bdf64965ab6d506bf461477c90d55d04c6"
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