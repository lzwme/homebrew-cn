class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.5",
      revision: "f463a945d57267e9691cede37021d9ddc5994f36"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44b5fa38e97a83865c701a2693f110bf44e3b8785b27345cde22c55defa64d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ab232b42438ab52be9dfdea342656efd3fb46d79bc678c9e2a17dc0c4d41633"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c38445c7c1068350ce35a6657d726f9b064b8d84dd8c72760eff55dc933a77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b53c0b91bb7cd638d8fe5eed5a21729e296deba4adf8785b0349dfa69dd247c"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab58b0e02e1b9c032a74f66abc04c8161aab5f99a115114e679b5eef456d6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eae0ce8312756206a9a5aea6e4661a65feab0b912b397b04f39605e3d594306"
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