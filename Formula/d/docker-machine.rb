class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.54/docker-machine-v0.16.2-gitlab.54.tar.bz2"
  version "0.16.2-gitlab.54"
  sha256 "a92bee9793d01280656379e6c862680f8b0f41aec5786098fdd5d9eeac650826"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a444ce011f2be0143aeae3086b4fe2c114dc55f0fdaeb448049a7f26ec8933b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a444ce011f2be0143aeae3086b4fe2c114dc55f0fdaeb448049a7f26ec8933b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a444ce011f2be0143aeae3086b4fe2c114dc55f0fdaeb448049a7f26ec8933b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50911cbc35a1467831fd32e44289bad2961a97fa9e9347097b4748ffc365ba6"
    sha256 cellar: :any,                 x86_64_linux:  "2b19ab85a14e35c248d28d96a56df8a9217864966de7c4c237bd93aedb4d87df"
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