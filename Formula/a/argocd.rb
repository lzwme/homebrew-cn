class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.13.1",
      revision: "af54ef8db5adfa77a08d4d05b1318a2198084c22"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf514efb1861a0e8fb27f6637ce3d67500d35e746f26e5dd188c7a87e0c4234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a7d40d64099e62eb5e87b3bf8b7b3e2470ec1b79cf0174aff43a48f1857d8d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acb6e14f4a406ce76760c68fd55c35ade1dfaf0bdaba0a9df6ae3e28113879e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f48b31ffb3014a195ad916e5421bee569e3614a33ebf5418372eb92ec8a2ee3"
    sha256 cellar: :any_skip_relocation, ventura:       "1cb84da5555d6db519c1a43f098e9bdbce2f18da3a366bf181e31fea43081f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c331a61a1991827a58164ac23a153de7e3a6519905cbdad25500b3c5844716d1"
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