class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.0",
      revision: "03c4ad854c1e6d922a121cd40f505d9bc6e402da"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "778bdb4aa1a39141b0c9f83547db72b67d2799608967abad0a0190c28f94f0c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa43b6a5ee3252e5be50bf872b14fb194cfb982a3bfcf928fda34874f088a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b65da213e97439fe812d48eafb5b6cfb5f55b1413e1025148cfb239167d747"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f1b48f4a848336b4d5f4af08c7b190f1cca9e8482354491016a084b52bebd7"
    sha256 cellar: :any_skip_relocation, ventura:       "46214d23dc6b2eed6f0d5cfab430ebd7c5618c6f0a6e9c6a9369c723ec7f1543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722162e90622029f9c025322c017f0f82405343f4d0f7b6d7ee2e1e7ea3d7547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d6115e3f5f2c3ebbf96e4fd31d83ca5a3049b48267717d7584ed6e9079d308"
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