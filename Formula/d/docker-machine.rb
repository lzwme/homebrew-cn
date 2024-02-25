class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.24/docker-machine-v0.16.2-gitlab.24.tar.bz2"
  version "0.16.2-gitlab.24"
  sha256 "172bcf784745806f39551caa5f565ab0dc792f1d26538c872fe9bceff49015ee"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d6f801470e111e4af61fec3a3251634245a0f05425e6a675937421ffc910c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9a7d404dc4476f427e6842a6b62eaec8235db0c5277a749721bca7b86936dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0249d159d91a5427d14b743ff999a4f22259dfec316ca860c08f3efb7e9a8ab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "98373c812405d274019105f482b7a1429bb9c7f79415da832e222ea9c544538a"
    sha256 cellar: :any_skip_relocation, ventura:        "a02fdc6641e5b6a38bfda97b830bd36e5df04224ff167b565582a427d1631356"
    sha256 cellar: :any_skip_relocation, monterey:       "550b3d0bf807293ab6c5eaf27e2da1f45e28bb64fb30a4344c3d795305bc947b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80eb4fea152ea10942a349bdd9a9742d6d89b4f69dbccd3c18732efaec3558db"
  end

  depends_on "go" => :build

  # upstream version patch PR, https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/merge_requests/121
  patch do
    url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/commit/8630d656313d791bd99a80e02b4efa9b3c95b250.diff"
    sha256 "96ff340785c1e7e6ddb5cec71ed3f2c0fadd8381a270b7f7688fc46d2b568f1c"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/docker-machine"

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