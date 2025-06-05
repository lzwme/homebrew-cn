class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.37/docker-machine-v0.16.2-gitlab.37.tar.bz2"
  version "0.16.2-gitlab.37"
  sha256 "3ac1792674d7578ddb17b94858c5add32e50b8e19bb04adf359f7ff50ed0324a"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2fe267cd164e4a07b4dfe00cd2cc9f27f43a603d3dab2430e902a027ba3f778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2fe267cd164e4a07b4dfe00cd2cc9f27f43a603d3dab2430e902a027ba3f778"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2fe267cd164e4a07b4dfe00cd2cc9f27f43a603d3dab2430e902a027ba3f778"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b39735ecee37deed9255136719330ca95e3064fa18454bc3b7f4747f0ea41e6"
    sha256 cellar: :any_skip_relocation, ventura:       "1b39735ecee37deed9255136719330ca95e3064fa18454bc3b7f4747f0ea41e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfcc139368340357e8ee7a4262d033aca90567663458d725a3bee1f57aa2f117"
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
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end