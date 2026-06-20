class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.50/docker-machine-v0.16.2-gitlab.50.tar.bz2"
  version "0.16.2-gitlab.50"
  sha256 "4f054e1ce1d3ec585f9097ec5f2742f1d9aec45c6892fc12167c44910732574e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6b563294a74166a58e5837bf6a3f4de7eb32edae83e6ef216f79af6914ce1ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b563294a74166a58e5837bf6a3f4de7eb32edae83e6ef216f79af6914ce1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b563294a74166a58e5837bf6a3f4de7eb32edae83e6ef216f79af6914ce1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5efb7d1ac1860ef3c78d4ce6d225ed9e9b7e48a54beec1d6513a3c8c93afc83e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943ac85624195e8e71931671496dcfa4377fe54179260a8daeda4aa9e8935a8f"
    sha256 cellar: :any,                 x86_64_linux:  "04f97407e6f315a7e6e12a5a3fa7b32594dfb310dfc74d259f747a9f363c4cdd"
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