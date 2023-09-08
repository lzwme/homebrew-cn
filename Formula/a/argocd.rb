class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.3",
      revision: "77556d9e64304c27c718bb0794676713628e435e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b7176ac071bbf579762998dc4af0145d210416f648354ebc8838f9542e349c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9db3ac98e0a9bfd8b9db87241402c52b695844d132cc5e7ded685e75eaf8b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32057ad51f591d757fd676674c0b19625f90562a45f99e7372fe7fea9b74feec"
    sha256 cellar: :any_skip_relocation, ventura:        "37d5cd4eb3a640c3f213a4bfb9eeee5ac8c53bf37cb649bbca594626b3a7d13d"
    sha256 cellar: :any_skip_relocation, monterey:       "842b734f6ac3f5017b44d5893b2e1897c655e7499e036fd598ef3d9ac032075a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c983ee6385921bbc57da27c1b2610fd48f19cc68bf00afe3b98a8111001d94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f049d6480e7efb4492d36e12983ea8ae336c95de6dab6e257998a728b83187"
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