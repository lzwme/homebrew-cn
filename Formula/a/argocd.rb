class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.4",
      revision: "20dd73af349fa4ff65ee939f71c03d3f467bce60"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "061c0f95410c5697b20895b4c177f517f80ff92d0a385af2014f525e9df7d005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20dd6d821109766faa5770d8a2f722cc9d9d9d23b2038bba7067963abb34b441"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e61906b6b4f4bc4a141beb15844d93bb610407ad2fb1d3233a5d2fe0be37f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe55d2adedc147707d837faa4df1da1c8bbce1019551cc096b245eba06a73dfb"
    sha256 cellar: :any_skip_relocation, ventura:       "12a87ab7662acfad9e6fb10fa7461608c1cc117f18138cf61d89acdf05f2de3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521d81aea9b6b127db72c7cf9663dd7a6af850bd133b94b525519a8159b6d63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d99a59426455e7d5ec005484bfd4ef2c0bb0f12b90777bcab7f15405816839"
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