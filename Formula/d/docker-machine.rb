class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.61/docker-machine-v0.16.2-gitlab.61.tar.bz2"
  version "0.16.2-gitlab.61"
  sha256 "c3f490b4745ae93def0dfa73ed6d042a07459a257df33b68a80622aa0398702e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3a04bb4757691b6e8569f7355b09f48d0ed22aece2e69dd9cbf1d05ecf7be29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3a04bb4757691b6e8569f7355b09f48d0ed22aece2e69dd9cbf1d05ecf7be29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3a04bb4757691b6e8569f7355b09f48d0ed22aece2e69dd9cbf1d05ecf7be29"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "274f3769db2c7500710c15c95a441f8343c871ffff8793d5ace990b67a4b9d21"
    sha256 cellar: :any,                 x86_64_linux:      "3f98b01b8cf5e836cc5ed46676c4bc64cb89d6099bd1873530c7cbf18ea1a817"
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