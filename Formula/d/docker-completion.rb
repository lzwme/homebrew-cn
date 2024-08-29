class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercliarchiverefstagsv27.2.0.tar.gz"
  sha256 "abd601fcf2223a550a9a8ef9117345f932b06ccb084bbfb8d111f6809d5e6c83"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b51303b5ae9d2fcc91d386c88ce127c860501e66ec1ddacaee40d05f4e2efea6"
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