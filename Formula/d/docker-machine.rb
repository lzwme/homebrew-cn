class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.59/docker-machine-v0.16.2-gitlab.59.tar.bz2"
  version "0.16.2-gitlab.59"
  sha256 "2d9180355fc8be8ca0788330393f549102dbb5e475b81f9f9f814f6a16338a90"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2110986f907e86b7cb3a4ca841254e9ae952db7572488e0f6aade7a87ab7feb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2110986f907e86b7cb3a4ca841254e9ae952db7572488e0f6aade7a87ab7feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2110986f907e86b7cb3a4ca841254e9ae952db7572488e0f6aade7a87ab7feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a66a5376d14496d07c23815747cb7f3cc7577f53fcc829199addca738c66848"
    sha256 cellar: :any,                 x86_64_linux:      "0a3ee48bff34ebb056577568914ef7cb18034ffac06e89a86afb6d5137c0132b"
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