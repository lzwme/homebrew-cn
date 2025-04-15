class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.10",
      revision: "3b308d66e2747dbe7028f95bbae8c7bdc8c2cbcc"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple majorminor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d177843942d4b7a5d7893a5cc5ab3b6def71a3d18c8ccd32e6a89e737abd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e863e0b709069aba80d4495ffdb10a47e09a0de55da4b7fb947a8d17804d86d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65470992c8216ef210fd048556b77be926ecb4cfa7eb728f1560e761de221a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d24ffa5448db451b12fddd76f5ae284c98d971dbc6cbd8365629f71ecbfeb8"
    sha256 cellar: :any_skip_relocation, ventura:       "41081dde98bcf44639e44c551638a88dca832630a6098eb4c1d8d3638d86e358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d05489734f96a2e3af899c628e5230293a4481924b3f2b3778f6b1771ec787f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c68b84fec926b61aa3f1d444d9590af53ef57742eac7388358c4e1d6078150"
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
    bin.install "distargocd"

    generate_completions_from_executable(bin"argocd", "completion")
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath"argocd-config"
    (testpath"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}argocd context --config .argocd-config")
  end
end