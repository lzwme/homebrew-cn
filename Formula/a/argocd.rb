class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.0.12",
      revision: "ed1e2397ef9af6d23b284e39d504308cdda1957b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f485d4d098872ccc64a014695b33d5a3cd89aba64169be954c07ba62a606fd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18afa923f5e5878790fee33ed711daa81aeb6ece8fd661708b1a56841981917"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "759387aaa631f21ce929d726ddb61aba718be1d3a5c726047e97a5d708b487e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "141bbb6dda8dabcc2cb7b2180de7b81697ebd012902c786d608b5278fbf7c82e"
    sha256 cellar: :any_skip_relocation, ventura:       "cf01ea656e4fda54799f0cc0ef0ac5f9c59c9b35bda72b05bc2bfc6bdd9f8577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ca367579543fa89e28a7013e423242c556e184aab2e5fa55fc3c8ba19f6f7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3dfd4dcd47892b5f6bacb605164db5d08e086536843c0bfce6348c90a33b93f"
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