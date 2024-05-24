class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.2",
      revision: "25f7504ecc198e7d7fdc055fdb83ae50eee5edd0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a88d9ad7372b9a1081a595823cda3189576966c63579d846af2169b78e926e77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc35c7fb23afeb83f86fe1cb94ec85326d9425d203c3b25dabf46b7ecbcfbb25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c7602b224dd33daefe45567099438e92a91b3f351f6bf1ec8cb6a6370660ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a2d97199bc8edfd91cdf563122a2f892e1e3de98ad888c6b33b93b1d7f2571c"
    sha256 cellar: :any_skip_relocation, ventura:        "23e1be1864e9fe7a240cedffbad535d85b295adf98d170d39798472b179e4067"
    sha256 cellar: :any_skip_relocation, monterey:       "9fff06ce527d89d339715fb62fbc6ddab0492e3c4a47e524c68f37add48d7ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb9b47071f8519162c54a6b3822434f3b4c6090b0923b0719150356bd2cb2d1"
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