class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.45/docker-machine-v0.16.2-gitlab.45.tar.bz2"
  version "0.16.2-gitlab.45"
  sha256 "59a27a7c9870995420236a3a9ab038043e94ea27332f2e4d8b8efdac1df4a43f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c32979643f365e3583433762efdbd9156c48b57315be72038ab1652a33b1ec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c32979643f365e3583433762efdbd9156c48b57315be72038ab1652a33b1ec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c32979643f365e3583433762efdbd9156c48b57315be72038ab1652a33b1ec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "05244adc0e458fd0d6503929758bf6f06e90bd9722a7ac8deb4cae161be5f62c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78a919ec6f4fd9e00b7fe015ac9b396493c6e3658ae7e11fe1918cc94dda9bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef1b1f73ce416334b377780b30f4e67f0f7ef68c04794ecbcb491d2632f52ab"
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