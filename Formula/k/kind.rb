class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https:kind.sigs.k8s.io"
  url "https:github.comkubernetes-sigskindarchiverefstagsv0.28.0.tar.gz"
  sha256 "14779aecccaa159a9221ffdc9fe92ac347553952a260c72671bd128a4419ab16"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "159c7e3d5d46249c62ab72e67fc97e57dffc35040bc347053bfdb5c0cc63d1c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159c7e3d5d46249c62ab72e67fc97e57dffc35040bc347053bfdb5c0cc63d1c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "159c7e3d5d46249c62ab72e67fc97e57dffc35040bc347053bfdb5c0cc63d1c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "128d9b7ce6d86b80451ea8bcd05876a0aafe7152bfade0a4953f255238a154ee"
    sha256 cellar: :any_skip_relocation, ventura:       "128d9b7ce6d86b80451ea8bcd05876a0aafe7152bfade0a4953f255238a154ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7849d211bf7eb6bebbe2148a7150f7d8f2ba2fd63ec1ed890e49404eec949a6d"
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