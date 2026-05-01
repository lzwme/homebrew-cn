class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.9",
      revision: "1b1bb48f981385cf40b282e965cf63419be3d93f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2fb6bd0560e94d01779d1285b21ede9537129ef061af3476b5bd87bbd88861e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f049a07e5e9b3ea413bad9f4ad3fa761c3c253e40d908fba330c98d73aed7b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e7574d393df79eb1fb6706ad6afacf8c44e34828b63b7e2e94b9f09e4be5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6df1feea9edf743396a85bad443d1d354cbb00a5ce03e704e6d86d9e044c7587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30ad561cd8269833a5695f3d2c97bf60f7bf1e4bc3582643a1906ef27637144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c39261da5a155c57c0358190bf17b7127473b8c5169d42015129a6fb11df84e"
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