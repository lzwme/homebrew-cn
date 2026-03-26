class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.5",
      revision: "b8b5ea61172f10e8701659aaa82ed383eef8578f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94b9146f68f82afd01ca1ca678b2904a2bd762d2b9e8bc0b519a9b12e339fe80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829bbc0734efe4b164179f89f0bd79f21c65c2a91fbe08b6befc5c17d9dc1156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90918866dd9f3fdb2e02afc57c16d00f63184d1614b0f812923161dc98751bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "b92c5c815d65ceb3f60758b83d5ab2a2d4d34625beea24414cbde567479f42de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c34a54e070ed95909174cc1ccba1f7e30bf01b4b7747f660643a3cb2f7437cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4965c04bcb208f6cc3b552fbc583ff7de20da638f404067ffd028bf368e96e"
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