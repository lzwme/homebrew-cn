class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.2",
      revision: "e258ee23c3e52266d407572f4bcdfe7d9ed36cb5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abadcabbc73e8ea325c315a0dceaf1d2d4b852b51b621e5a7b05857f4f8f98e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a7c1a62432c644b864f2a1f8889ed910ec1832c86eb302fdaa0789accce9cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e20e94a623a4be88351fdf0c1d036b1faf2e8e6ea09b73ea55a4b010111831"
    sha256 cellar: :any_skip_relocation, sonoma:        "293f3fb2db435cdd0bca86cb62219f18401bd6123afbcaf07f727028155fcfe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ac8084728f63831eb16abd15f1a2e70c78994cb1d46b3d05cca4b75dcd929f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ef74768ab40c503ab9a702798732772fcd3e4e86b58894e41e8260d359266e"
  end

  depends_on "corepack" => :build # requires newer `yarn`
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls an Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end