class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.1",
      revision: "fa342d153e0e7942938256aea491a68439a53c44"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e98cabfcf5ed907bb91893dfe4c2a835ab84b5528d552bf9f9a4bc7262c691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128c1eacb2b1f61de678002e3e2725f35d86741c28690e5711d3f832d0064af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8889a94d0a61157f2d1417c21779668b3d20df5c0e194298312d7f6a43efaf28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1cb99e5df448a40a632cf6fb41bf7c28d3bb365b338c8bbff020c07101a989"
    sha256 cellar: :any_skip_relocation, ventura:       "c84c3ff8892a7d06a434596c844c6ed28b7f2bc3969934765eb8603171c19c14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55bb1d5c9489e1287c74fbacc0e12c476435e129bb967dee99c9723dbd20ee17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b2ad578382f48e92bb9809ccc2a5d56674ee7a8739867ea3ab5bbfdbb8f6d8"
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