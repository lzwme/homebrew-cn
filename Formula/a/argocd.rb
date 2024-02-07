class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.10.0",
      revision: "2175939ed6156ddd743e60f427f7f48118c971bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f271aab68285ad871502c44781b10bf314f2026c6112561477efd5d3fa6b55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f79570be9629a08db0de29ffeafce24dd3a837e0a1664259ea58a94309c3e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583050bcfa73037d118ef1371ca0c929a3c75616280573029a0229384fe49bc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c1458692fc56824e087b970dbb5f084280ef1c3083476cf7476430e87a268be"
    sha256 cellar: :any_skip_relocation, ventura:        "ea2d7b99c74803c022db995fe6b5e9469b680cc871f8948f67d305b5a29e738c"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea35e917b4941edb4c26bf3efea911fd0c64f1352f1902c479d5a10ce5c06dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29b045fb0290f1d5d1eb2250df4d833ad57478e25d3ad5fcc0d80d4a49749a12"
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