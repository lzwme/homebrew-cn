class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.10.5",
      revision: "335875d13e018bed6e03873f4742582582964745"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d35fee775f9040bd6fe07e888c93454d1d545e3d8c3bfd959cef602bf7237cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb4f807d437e405c4cd29be8bc4b947dbe75774cadc768a4076f6aac829a10b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32820a3a7590563efaac1befb1164edab217a89ab14368d0198a639226b764c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4f8a3d0b81a6939a700eb90c5b4c320ca3b64992541065634425b8f748432bf"
    sha256 cellar: :any_skip_relocation, ventura:        "41c4ef3461e86a58d5a0a6507cc46df2efe066e59e963deaaa186fe047cebdb9"
    sha256 cellar: :any_skip_relocation, monterey:       "cecfdc3baef4183a9eb42310170920e8792e17533f6e9572047266a8251fa3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1666d0373c210c786b532eb90bcfabd864f97f82c40444e729abf19dfd83ee9c"
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