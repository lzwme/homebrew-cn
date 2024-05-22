class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.1",
      revision: "9f40df0c29eca7e45a73f802f033dfd1ed0068e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3e8091aade9a0cb956186003b51ef65e29d8adc09e7e0bd20937daf957c7992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90f8d1b8cbdbe5562b9318588e193dce41355bad2d743ecc744b4e1c4541836e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e042b5ede17f487cd406c79cd629fc7e16d5bd9e0a83e2325bd63c3642e2c67b"
    sha256 cellar: :any_skip_relocation, sonoma:         "763afa562809d2bc6209c87dfdd581ca8a81cb2a1011e77317884cc785f36fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "4ddb6ee7cfbad7e039d0c135ce32d8f8cdf68ca22e6a44cbf942e1dd8c64b560"
    sha256 cellar: :any_skip_relocation, monterey:       "c50975c563ac3bbbd79cade318f87d0dc711c6c6ad58c0e23dc390e47d89a1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae754beefad049c58346612e04ded902e480b2f197e230d25aca8b7a09750da"
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