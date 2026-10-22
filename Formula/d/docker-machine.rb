class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.64/docker-machine-v0.16.2-gitlab.64.tar.bz2"
  version "0.16.2-gitlab.64"
  sha256 "7c9f9cf281d37f04d6bfd8512ee6ca032003bf1fcfb525e3d2172ab4f9dd8596"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07a874f293151c87e1a1428e3d5e1ea8c368985035688a1023438e10d6cbbbf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07a874f293151c87e1a1428e3d5e1ea8c368985035688a1023438e10d6cbbbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07a874f293151c87e1a1428e3d5e1ea8c368985035688a1023438e10d6cbbbf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f657f98da5fa0ca06ab33ac9575e2877e1445821076e8756e3e0f5d5035f9f02"
    sha256 cellar: :any,                 x86_64_linux:      "364aaf71336589c3856a6d0db2683cbb58bb858b06898c6c6d49051357adb87e"
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