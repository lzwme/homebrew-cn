class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.34/docker-machine-v0.16.2-gitlab.34.tar.bz2"
  version "0.16.2-gitlab.34"
  sha256 "3375d3a007889a470be2a7f4bcbb3183db3ae94940c2b6f0329958e947bd55b9"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44f5c1afc536abb61bac62719f5f7d4b501a28194d073dc5cf9fd4179070bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e44f5c1afc536abb61bac62719f5f7d4b501a28194d073dc5cf9fd4179070bcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e44f5c1afc536abb61bac62719f5f7d4b501a28194d073dc5cf9fd4179070bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f840facb170043a53f2df16e6ea9aee873775ea75857579b225ed9678a3af06"
    sha256 cellar: :any_skip_relocation, ventura:       "2f840facb170043a53f2df16e6ea9aee873775ea75857579b225ed9678a3af06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65efefc6874a9992bdd20fc9d2f1b83afda6b963f59dbb4e2ab7fb0a12ccbe68"
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