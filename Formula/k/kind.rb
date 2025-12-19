class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "f4aaa1f572f9965eea3f7513d166f545f41b61ab5efeed953048bdcb13c51032"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f017ee624895990102782005a93ef80f0d85f5c64b028f90adfd2cec472551de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f017ee624895990102782005a93ef80f0d85f5c64b028f90adfd2cec472551de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f017ee624895990102782005a93ef80f0d85f5c64b028f90adfd2cec472551de"
    sha256 cellar: :any_skip_relocation, sonoma:        "8329ed3e4924dd0a23c9fdbd6f0f3580a3b045929abb2dea6393d4679945c8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded1dd83cae8b599488012425918edb5895e656e9de5c16f5d528f307a0a9e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59caf2fc5bb0ecf717b5b0716098389e1ed1e3fa7242e5bd0acff0245480783a"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to connect to the docker API", status_output
  end
end