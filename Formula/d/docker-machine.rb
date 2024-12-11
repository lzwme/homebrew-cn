class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.30/docker-machine-v0.16.2-gitlab.30.tar.bz2"
  version "0.16.2-gitlab.30"
  sha256 "024e70a2a1067cbe481fac930bcc06446ea4a1c627c2360127c43b1d709bec7e"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247bf9c1d7c27d6950483d4dfcb9aa3aedd6028b21179762d617633ee63d20d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247bf9c1d7c27d6950483d4dfcb9aa3aedd6028b21179762d617633ee63d20d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "247bf9c1d7c27d6950483d4dfcb9aa3aedd6028b21179762d617633ee63d20d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c88c09f080a7ddaf3877cec4553dd5c3d4352ac48ecf1733eb9246d8f1615f4"
    sha256 cellar: :any_skip_relocation, ventura:       "7c88c09f080a7ddaf3877cec4553dd5c3d4352ac48ecf1733eb9246d8f1615f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedf535c7d5fad36fdeb31243404e2f842ca4473d43d18d34e924ac9c3de36c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-machine"

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  service do
    run [opt_bin/"docker-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end