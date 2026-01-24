class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v3.0.48",
      revision: "6ce0121a03697a6976656fe1f13dbb171a1610a9"

  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c97001e9cb742424c2ee497bc7902f60226fd234208d3a680f51fac7e5c99151"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6769db2f0a34ff6a077a6c211935a7cda16b15bc33de8664a81deb0cdf19995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ff718930cc9da58e818cd200c4ed59d20daf1e5f124eefbc5d84d6fd3ee980"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7b6e53e251a20befb1ee00147f496511d95f7bb531235081cdc75ceaf2559b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d5f9710ab9cc769ba498334512126d3e797cd6b78c00cf1cfe1cf332102e03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b7e30c36b4440ecacc12aee6cac02b08deb707b8a689dce688f01ff03f3c01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra,
                                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end