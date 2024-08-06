class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.12.0",
      revision: "ec30a48bce7a60046836e481cd2160e28c59231d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42a7b2fdbe4ea51c4f0ba51d6f239740ced9377e77625ab8f199612fe81f9781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa89ad564f5949123e3a92b155a6bcdbec8900ee292bfebad932fa4518d6734d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa08d33d81843d911e29dce61179ad0b63a0b44f0a8d037cde5faf570d74bc35"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f1a50ac2ac712104dfe54db67ee201210384246d60732e76c913267347ef68"
    sha256 cellar: :any_skip_relocation, ventura:        "225327957d4418184c5deda742835c5149727a55b218f1790142b9581aa02157"
    sha256 cellar: :any_skip_relocation, monterey:       "d29ddd22166f25a69d09d49a953ed107e0b6e03349cac9d0da90897653546dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc468bb02f6f502a6497b19aedcc7ccae6b9af429b284ab175f549a3526f94c"
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