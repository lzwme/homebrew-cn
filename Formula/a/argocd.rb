class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.0",
      revision: "fd6b7d5b3cba5e7aa7ad400b0fb905a81018a77b"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abe5e5154cdc75a257a7953be4a46b83a2a9fb6b62ba06981821a6e50b42590b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac390b747bc40f24847cd8f12e0c4a8cfd1622d876ac5c095e9941ba03d07b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69057dce95ad0741d199cc93624077ff5089bbef3a3dab57f14b2cd06623135f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fc031e593a5d11532af74075913da63bce8d93eab9c1dc713bfce5fe76e116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6229d9d96bd2cb8caf37900b7c188a1d2d94d3b1a5cb3c25afac799a5e36c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70bc21c2884a042c505a7a39bbf699725ff500a2a426b60cd8756c1f7e9abd09"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
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