class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.62/docker-machine-v0.16.2-gitlab.62.tar.bz2"
  version "0.16.2-gitlab.62"
  sha256 "499a62e0eb71a8c7e6bb130f1b9f928fa0910beba30afda95be06ef35243eb5e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd91ec6425c15e4284f67ee386bd76abfd459ba9652f9aa910ec1bf176055426"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd91ec6425c15e4284f67ee386bd76abfd459ba9652f9aa910ec1bf176055426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd91ec6425c15e4284f67ee386bd76abfd459ba9652f9aa910ec1bf176055426"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b1f2db69862961106ca3d5c611179acfe735af69bc2c8498f957f6a758c1b6d"
    sha256 cellar: :any,                 x86_64_linux:      "4136ce26f249a2659c818198e2a442f9752cccd54f47f473b30ca929f6cf7e10"
  end

  # After Docker ended support for original docker-machine[^1], we have used
  # GitLab-maintained fork. However, the fork is now officially deprecated[^2]
  # and scheduled for removal in GitLab 20.0 (May 2027)
  #
  # [^1]: https://docs.docker.com/retired/#docker-machine
  # [^2]: https://docs.gitlab.com/runner/executors/docker_machine/
  disable! date: "2027-06-30", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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