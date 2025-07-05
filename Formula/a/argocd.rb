class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.0.6",
      revision: "db93798d6643a565c056c6fda453e696719dbe12"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44f7dc5ab8c422186379784262c8d0ac8b7f7245a010d919d2745baacc12de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9899f94da866275a0f96f0f980071c013f4b35655ae1777240e348658e906e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c47dde32552f5ea66c399ae790c5f3aa5b17038f92c5870dedb4f122666b2b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "6444e5d5f752ba3dacf153d138894a9f20a5d00c76fb55855a39063bf01a4f19"
    sha256 cellar: :any_skip_relocation, ventura:       "0ebbe72e932edd29546a2b67eb4cc7463c95bcf6e5c4fe15c9e15dd82eab8d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c3e0a4438dfa1ad21ad52e22c39f4d1e27cdddd229063e384da4757cdb01e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b7ee75891fc1b5ce7a24ecaacc2824205a8e3cbdfcab7c3e44c66a9cd14368"
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