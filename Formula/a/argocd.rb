class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.9",
      revision: "8665140f96f6b238a20e578dba7f9aef91ddac51"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c35f0ed71a62617626183bbdc2d2eb7c37a4cb7785b8006e2efae911a07722"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462eaad4052538fa1778a8a1b2659186fedb2dc61b4afbb42577659c4b2bdf03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "669665be206d9ae4f7f82e634ac3883eebe91f28a771efcdb89fcfa782538c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "073865f2db6dd43d3fe3b9769355dcd0c0db6e979e83c380d5756fa7b7fd6d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9212ffe6565ed4857de5dec2da45a2eb3096c591b1a75ab6478155db0fd04ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00be088db7e2fb327df3e5f35f27be7d81a1d57e6438d0a298bedf10db157aff"
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