class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.53/docker-machine-v0.16.2-gitlab.53.tar.bz2"
  version "0.16.2-gitlab.53"
  sha256 "6dcf3b1e4f05d3fbc2de3674e7e5902ab2db170a1eaf4514f8841a72dd9fe282"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cc2f8b140a658a2d16d8cca5a649c0a82800401f7a3116ce3151d4430107d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc2f8b140a658a2d16d8cca5a649c0a82800401f7a3116ce3151d4430107d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cc2f8b140a658a2d16d8cca5a649c0a82800401f7a3116ce3151d4430107d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "68e48b7f28af03c817c2952adf701c53f343bfc1259f886258ad0e43fc5ba8c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be58d30716f2166a9612e14cf8febd3161e2d0b5594b02a958ae012a3f17999a"
    sha256 cellar: :any,                 x86_64_linux:  "d84ee2fbe9a77dcf3488269ca24d391a8117f305dcda327c0d05164a61f9d958"
  end

  # After Docker ended support for original docker-machine[^1], we have used
  # GitLab-maintained fork. However, the fork is now officially deprecated[^2]
  # and scheduled for removal in GitLab 20.0 (May 2027)
  #
  # [^1]: https://docs.docker.com/retired/#docker-machine
  # [^2]: https://docs.gitlab.com/runner/executors/docker_machine/
  disable! date: "2027-06-30", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/docker-machine"

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
    assert_match version.to_s, shell_output("#{bin}/docker-machine --version")
  end
end