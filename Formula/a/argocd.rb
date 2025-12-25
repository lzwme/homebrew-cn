class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.3",
      revision: "2b6251dfedb54de40596272a73ed1fb19d740219"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026b51cd9b34e1fcbd0297deb55b368baf8cb6d6de2a97f3c6577c7f523f4b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b39322e70b0ddbbee9053a0da1de3ab3fc6dd7f715681c3cdc33b393ffa03e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414a194b1434d76d93842e79fa19e94a8f83acb0ae40e03d5f2944693f0bf4f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa0b243086940a8c74db483d19ad5b937a88866c2bf039955ece1e9ba23e58bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "972dc51e16a0124f8270e9b82fd0b6b536549587560355d1d3164f6416c8203c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad709f98b77f06faee9c83a2b3c25db5c0c7a4abd7fd805703951d8617eca90"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end