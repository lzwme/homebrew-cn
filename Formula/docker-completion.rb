class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.4",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, ventura:        "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, monterey:       "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, big_sur:        "632bdfc758fb664784f80ae5e63037220352d5316b9b4bf9c041ef745b01add8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4c8296f2862aca633c37108dbc73f8143b35a225b75ab0935ef5f882f9cc33"
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