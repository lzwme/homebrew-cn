class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://ghfast.top/https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "835365ef3ad78871f855ace4b97b789ed613bdcf6384f9ccedd26772a382d0d4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8e000f4008d0b090224802bdff59f6314cd94676f42ad6e49931f8708261ed7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79426f4a39bedd07bbe9316e4805241a99faff5cc6adeb6a8fd8f3f3a8232476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74e772031eb2ed8557832679c6d8ee5164182839305b689900099793f5fc048a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65e3e5c9ab8fff5a813f87d1663495c0e2d7878a5ccaec148dde1344ecfc8787"
    sha256 cellar: :any,                 x86_64_linux:      "c6cc7e26fdc0daa1be7ad335546214adda26cacbff1e6c5a3e0aecf9dd94e6ce"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    # `go generate` downloads the disposable email domains blocklist
    system "go", "generate", "./..."
  end

  def install
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end