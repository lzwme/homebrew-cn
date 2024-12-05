class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https:kind.sigs.k8s.io"
  url "https:github.comkubernetes-sigskindarchiverefstagsv0.25.0.tar.gz"
  sha256 "016c36750be5c5fb81f70e4675ee0a4f278dd929f05273184ff68cae112ce71b"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskind.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be14b4a408395f01600cebfcd8d6489eaee94e1fde2347af6366af96809b92df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be14b4a408395f01600cebfcd8d6489eaee94e1fde2347af6366af96809b92df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be14b4a408395f01600cebfcd8d6489eaee94e1fde2347af6366af96809b92df"
    sha256 cellar: :any_skip_relocation, sonoma:        "932cfbef0435bd6c5e0af9d7694a78a2618238a48c2f484a90a169c04bdc4ddf"
    sha256 cellar: :any_skip_relocation, ventura:       "932cfbef0435bd6c5e0af9d7694a78a2618238a48c2f484a90a169c04bdc4ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3913eceb0fa7ab5899ea8d6e87859fd21978977f88cf068058f63f367f39baa4"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end