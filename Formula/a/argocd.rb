class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.13.0",
      revision: "347f221adba5599ef4d5f12ee572b2c17d01db4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f38f81021195a99a879966f3706e81d4fc5e3feae621e1510a10d1ba5b98ae6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "075ac92c7373a90459803d5b0e98840e61a081cb25c74dcc61bb5df69de1a39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8124afce24dd171f5d8c4ceba2eea9ac503b76e9f969d7978241602faa7611e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7ccb8efda2d62085ec83f601d3ad4c7a436c7b4330290d95864e054d7081e0"
    sha256 cellar: :any_skip_relocation, ventura:       "9e3c60189a6cc4f2e3f842ef71401282e68e145f51bc5b01e94cde3aedd10d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2531de98a1bd34d83e9b10566d935c26d585fa142f2ae0720e9024e537164a9f"
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