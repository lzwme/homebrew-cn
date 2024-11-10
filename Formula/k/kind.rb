class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https:kind.sigs.k8s.io"
  url "https:github.comkubernetes-sigskindarchiverefstagsv0.25.0.tar.gz"
  sha256 "016c36750be5c5fb81f70e4675ee0a4f278dd929f05273184ff68cae112ce71b"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d75dd243caf5a92783400b71472fd98e2c806e77f40dcb7c70f7cd081f2bd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d75dd243caf5a92783400b71472fd98e2c806e77f40dcb7c70f7cd081f2bd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21d75dd243caf5a92783400b71472fd98e2c806e77f40dcb7c70f7cd081f2bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "072b9207013e8a64230fae40fdc55d3014db5f42574c6dc988f899ab4635d8bf"
    sha256 cellar: :any_skip_relocation, ventura:       "072b9207013e8a64230fae40fdc55d3014db5f42574c6dc988f899ab4635d8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e68b6008d3d57cf4cbb5a497e4e99f094e3916c22e187314dff8903efef22b8"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end