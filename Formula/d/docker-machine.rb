class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.38/docker-machine-v0.16.2-gitlab.38.tar.bz2"
  version "0.16.2-gitlab.38"
  sha256 "852e9a1fa425156cdc5040381b0c7d0f2831f084191b4ea54d5c8eeb59b5b1a9"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb1a08020d5e1e0d2c82d30c99c3fed3b21a4661a1a4e885b3c598d85f50b6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb1a08020d5e1e0d2c82d30c99c3fed3b21a4661a1a4e885b3c598d85f50b6ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb1a08020d5e1e0d2c82d30c99c3fed3b21a4661a1a4e885b3c598d85f50b6ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "510544759483ea2dd246d174121046b6e151a4905650a18e3b2a34a21a198dce"
    sha256 cellar: :any_skip_relocation, ventura:       "510544759483ea2dd246d174121046b6e151a4905650a18e3b2a34a21a198dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71549bdc5d0c785faf17987aca38811c0cb7cb7511640849c9cf9cd8789a433"
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