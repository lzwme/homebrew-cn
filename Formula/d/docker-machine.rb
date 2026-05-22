class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.47/docker-machine-v0.16.2-gitlab.47.tar.bz2"
  version "0.16.2-gitlab.47"
  sha256 "608f31480668bd628fd93c3fed98d457ea1028a23d157931a5dce6bd44b2eeef"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27926ebe1b75acee2bf059ca628d780c08700f0b4a3e3326088f185b6418af2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27926ebe1b75acee2bf059ca628d780c08700f0b4a3e3326088f185b6418af2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27926ebe1b75acee2bf059ca628d780c08700f0b4a3e3326088f185b6418af2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a97641a4abab977dc30bc09f9a9f82b9906e8239e5dae79c94150d9755b9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4048485e634f8bb98ed7f8c7b9b798c35730786bd064bc40885136ac77bcc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e87508e9dbe1a668bd9524689115d656aa719ff273c699bffe6d8baf11793c1"
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