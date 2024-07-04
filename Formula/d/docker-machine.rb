class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.27/docker-machine-v0.16.2-gitlab.27.tar.bz2"
  version "0.16.2-gitlab.27"
  sha256 "bc392f1588321c63216195fe10bca919838b4ed8e2bb738396f15e20363c75b7"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "392b978d5b786a8696cb0db303d3a41cea92ac4b24b380798a23bb21054029f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2c54eb39c511cac3581aac577eaa2914b473fb38126fe5f94d75a1fdd24b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce6281c69e5fce85bca77dd0aeb2f77e4e4ff7218c5a3e56d507b1538dd1a063"
    sha256 cellar: :any_skip_relocation, sonoma:         "616047472bd1c6f8a4953f2e488bac01b9d26d49dc5fbd192531ed1016bb240f"
    sha256 cellar: :any_skip_relocation, ventura:        "a20c1ff0942fe77fc86bfd98d2fb0b72cea5d1361bdc88fd62e10301d3b370e5"
    sha256 cellar: :any_skip_relocation, monterey:       "45a5a48beeff720a97af027eb47e363f2b219aae08b7fbb644c2544fe341be78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23fdfe14bcf948a34184ce77e1edc8c5a90570de77c7d0df8524f3ab922223bc"
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