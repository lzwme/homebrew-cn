class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.6",
      revision: "089247df0f15e64813d00a2d1271a2095feecad4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "599a2b307c54b2e75299f6d7ea4adef3856700327410c144af8743a523ae25fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5347faa1257c39c6a70a1d97185ce32a58e779b1d7ec8655aa968c6254804d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4638bb103888668c6a78f0f60d03946bcf8d0d9a8ee3ea353067f50f96b583e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3b3cd776664ac2b2ed384a39dfb7d112eb43545c02a8dcac59f1e726192fa61"
    sha256 cellar: :any_skip_relocation, ventura:        "0c864df12b9939ad74fb7b63f8ec60be4c984b874097e8321c9752efe68456c0"
    sha256 cellar: :any_skip_relocation, monterey:       "752ecf1df7892fc08ed950612ddd35706e36cd2eb205441c72886248c23fbc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c956c6ffb837e804e9ce5becdad220ea40cf6c0fcf5387880023881f60f10c"
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

    generate_completions_from_executable(bin"argocd", "completion", shells: [:bash, :zsh])
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