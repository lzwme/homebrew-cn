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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6675ccccf401207c5bf9649b6f25ff4c0764c2c81ff412e93858b99617a50f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d364b2ffcac01f8bda0aa725679d85d21d83720a80dfc91845e7ee6b3e80235f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df845234d44be09fbebdd60424f244f98eb741e69b67e81c66f1829b8a2ed46"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9baaff8ced722ff2c5f7c3bdaa4b442f6412e821132c83a25cd6d6fb0f7112d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e585f90d52a510ef911e0dfd69a10e7af0bc872ff3960e82f0977adc25f6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1515e7b001f72264250c28b5de29698642feb5a4f336c6b9aea85fbf0b0d2c"
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