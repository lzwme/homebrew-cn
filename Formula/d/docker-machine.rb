class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.58/docker-machine-v0.16.2-gitlab.58.tar.bz2"
  version "0.16.2-gitlab.58"
  sha256 "45a2bf62d4a1369a188e853139d6c54ea7e5ef458df3d07d13aaae1d17b9a6ab"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfffd5a99a54e4edac13288c31aec44f20c61884cbbc110d54053048125e7e64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfffd5a99a54e4edac13288c31aec44f20c61884cbbc110d54053048125e7e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfffd5a99a54e4edac13288c31aec44f20c61884cbbc110d54053048125e7e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a78dbed8f381deec6c20f94a1bebc40258a82a31adaf678f53c0d7d82122558"
    sha256 cellar: :any,                 x86_64_linux:      "94921050cee2da89a5723e78da8f508ce590d58ab3d12cf999b416413ba4a0bd"
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