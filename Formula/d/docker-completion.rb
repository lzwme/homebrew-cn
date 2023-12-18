class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v24.0.7",
      revision: "afdd53b4e341be38d2056a42113b938559bb1d94"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, sonoma:         "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, ventura:        "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, monterey:       "9907e5be8244124f0393748cbedba2a642930d3eccdc63ac9705eae79f997398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e54187b5ac5a263c5ee9ec68f84b1c5afca652a3efb354b1f80da3957402b3d"
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