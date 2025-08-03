class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.40/docker-machine-v0.16.2-gitlab.40.tar.bz2"
  version "0.16.2-gitlab.40"
  sha256 "fcc9751e80af8aafd0ecfcd5380790cb6daabd926e6ac3183c5a120bb3f33f87"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88cc0fe066546dc59a2a55506ac39dd0b853f0f96032d048646f5431c91b9bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88cc0fe066546dc59a2a55506ac39dd0b853f0f96032d048646f5431c91b9bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88cc0fe066546dc59a2a55506ac39dd0b853f0f96032d048646f5431c91b9bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a8cf53a58a28c8c7321546dc64eb6a563494c9bb8e60c32aee4810d63dcba2"
    sha256 cellar: :any_skip_relocation, ventura:       "47a8cf53a58a28c8c7321546dc64eb6a563494c9bb8e60c32aee4810d63dcba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f0d01941d25480642962a14e365e31f5cb16ebe44e5f8b5440f418a14a32df"
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