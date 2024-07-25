class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.7",
      revision: "e4a0246c4d920bc1e5ee5f9048a99eca7e1d53cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81dcae35306a14a52059948ecca97009923a1cfea6bf44f899100a4f1fab0d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe5deebce60682e837e8061aa23496bffb4ded4a4e80a9724badedec0f724f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56dd99c54f691e568bdc2a66c28755d88c092ffddb90ad18263e26ab337ff52d"
    sha256 cellar: :any_skip_relocation, sonoma:         "84be74579b9c787bea2f91107125670bf4fdac44df33b1cac61c5e27d374bb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "58f1339e7e43d32532cb07c107205593eca95a3de24db238d78b97baa1c35aa7"
    sha256 cellar: :any_skip_relocation, monterey:       "700dd30950f7b5925b7991eb41229c71d04df6ff2be50169a53ab49160a6caa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36853ae253f7323bf7d03454da9f7d0c3e5d720c34fa83f429409b2bfbc0097"
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