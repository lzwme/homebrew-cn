class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.60/docker-machine-v0.16.2-gitlab.60.tar.bz2"
  version "0.16.2-gitlab.60"
  sha256 "b112ec9eee51d7fb76dd003b108aaada07598f2db1ee0a88ccc7f6c2ec156d27"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75102cf9383192f2bcde17f1b8557f8780c492de4a4466a484d7e9f96f4819b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75102cf9383192f2bcde17f1b8557f8780c492de4a4466a484d7e9f96f4819b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75102cf9383192f2bcde17f1b8557f8780c492de4a4466a484d7e9f96f4819b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d05e7b46bc6f5109c1b4cfa4a00ad778494df35fe4e5ccde64cb7f0d8b334d17"
    sha256 cellar: :any,                 x86_64_linux:      "2d280ae9d11e2d447e22ae6798f342a55912ba718628a2d23dba371a3870cc11"
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