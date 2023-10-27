class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.7",
      revision: "afdd53b4e341be38d2056a42113b938559bb1d94"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

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