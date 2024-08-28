class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.12.3",
      revision: "6b9cd828c6e9807398869ad5ac44efd2c28422d6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a4e866b0e9d62e6e48ea624cff87e65b999a07e63645ba8b7de6c6049fa05ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83dd13187acc6e4114b7ecf6abb76e6ca17586d5103f68e8dfa468e437d14979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a9329ee81009530b9d3c66dd2d2e85eafb831eda6641fec836460c57b22d33b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f022d7813f194b38333842dca4b83f316f6319fcfb910f23930f8ebffaffa6ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b30b12086c454b6baee4271ac7926991f1ccdd418d0f0db499f1a7e6c2531e10"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2296c1289221b4df4b452da6c55dca2b8f86c861e768aeee457f22b8fc49aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fb62d6d036890d5f13066a43d0b6c5fe767ba525577cca02cda2c49032624c"
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