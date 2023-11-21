class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.9.2",
      revision: "c5ea5c4df52943a6fff6c0be181fde5358970304"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dbfbd667b9f06f3c34ea6348cd54b996553947516bc225a7bc79a01ba4224a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b5f1f8581ea7675081d67e49ad70f821456f1a1de54fd3c771a781feb5f348"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe78b9f742e7a7984d5855fc5f27d3142372a428522af9f243190b6d5b545364"
    sha256 cellar: :any_skip_relocation, sonoma:         "9de35acc9e752bd78373e536c5d256c23b75a64538ea6dc0207910c1daac11ab"
    sha256 cellar: :any_skip_relocation, ventura:        "bdc0d16c4a5d1db1972fba03108c7fb7ebf7f44117736e530ecfd03f9898b686"
    sha256 cellar: :any_skip_relocation, monterey:       "663cc5ba670284f78b1911bc92a1bd806cf238575842502ac8eb76ccbca4b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24dc05124cf00a1f0519e9e9ff937505c2d0e99ada85f7adff0780de9960b00b"
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

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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