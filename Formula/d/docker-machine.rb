class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.49/docker-machine-v0.16.2-gitlab.49.tar.bz2"
  version "0.16.2-gitlab.49"
  sha256 "7cf1733201c09486db68e5d1a7f89bf6ecf18178452239173736d48eef2d42a1"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e8c990ab50187d4097095b3d4798a5632074e8872a8f3e2733d22e065df4d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e8c990ab50187d4097095b3d4798a5632074e8872a8f3e2733d22e065df4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e8c990ab50187d4097095b3d4798a5632074e8872a8f3e2733d22e065df4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "633d2315c13dfa2f2e90bb95aeaf43c0cc337b0a25b3a7d0b04ba085c4901fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50a691efd6744833e687a853d1de30460a7a8817c94a327958b7ac10769828b4"
    sha256 cellar: :any,                 x86_64_linux:  "da4e1d5835ad4a07e57d237b4184c3c9ea5704727b7953275470027baf14a032"
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
    assert_match version.to_s, shell_output("#{bin}/docker-machine --version")
  end
end