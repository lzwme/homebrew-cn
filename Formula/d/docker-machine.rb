class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.33/docker-machine-v0.16.2-gitlab.33.tar.bz2"
  version "0.16.2-gitlab.33"
  sha256 "1f0e1ef0ab3fc0c4c43cd90a34471dec7e6faf61a6baa4fe1268364c83ed0dbd"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fe2f67f8f6ec766ec35e8b88b8d7f773b040d5156576560259434ec2c1935ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe2f67f8f6ec766ec35e8b88b8d7f773b040d5156576560259434ec2c1935ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fe2f67f8f6ec766ec35e8b88b8d7f773b040d5156576560259434ec2c1935ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ddab15cb47e95b1bc485dc02bb41a65ecc6703fa6b2d957034eae94697e11f8"
    sha256 cellar: :any_skip_relocation, ventura:       "6ddab15cb47e95b1bc485dc02bb41a65ecc6703fa6b2d957034eae94697e11f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d24027d4de8fd85f240408006ceba98c141c9b2317776b114716db3d90f27e"
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