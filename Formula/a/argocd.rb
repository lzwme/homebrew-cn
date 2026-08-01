class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.4.6",
      revision: "e1becb74c728a992804d39c3ceb2e9e6ae58f0ae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6af74186c85a3011ab149471bcc376f242de236172fb8984f8fa40bad0770037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4950d4f37b4c3f284f636adff5b36aab71a69eafeba35088fa421d6a43c76ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36607b6cdd367b32547f548b928b79b823769aa6edf8f85e9baf101773b34a91"
    sha256 cellar: :any_skip_relocation, sonoma:        "68ab5675ea2b915cbab1bbd6b21719582571ce578e5a72fb0fabfcfbeb2f6709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1feafc16720ff7728a337067cabaa903a54a13caed9fc221b503c549dd2f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c5dc18bef00aa7f00d7aa4088598ed7976ac2c9f03727859717f65cb4afccbc"
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