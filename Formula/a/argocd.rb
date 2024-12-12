class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.13.2",
      revision: "dc43124058130db9a747d141d86d7c2f4aac7bf9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eaedfba6311f95d04443f85235b78e91ec179f617795ffeb0b7e236552d185f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9316c433729b5697eb5abd12889018a6a7d02eee958a732bc0a31d1abb214be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e146f49bc6b9d79879b44cd06d5eb03347b51087cf5e4c088c7de9ff41d3c446"
    sha256 cellar: :any_skip_relocation, sonoma:        "f677574686809577fc4be794cb289d615a725327395f141e0b9cf2b944d3845c"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4cf4cf3c1e5c9d748b5fd03191229f43546aada326525b3077ba39a539ac96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb07f2359ecbaca48566e6eb8006c80257e0964c6234466ef8c8c68c42999cf"
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