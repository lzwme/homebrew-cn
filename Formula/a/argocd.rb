class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.2",
      revision: "ad2724661b66ede607db9b5bd4c3c26491f5be67"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14dd2461403d6f3f9004519ce5a5158e0f33ab76413a40b8e6a424f2b1844036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca03ca2d83362b1d544e1b3149a40fa30bbbc39e68d2e03f19b2a2a26ca73ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba0c124a5ce45de455d53da6ef6c0d90a5c1701125ee62f4394f937280472c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "37770907d50d528d75435d11770b15462d5af6edfb853f871ba02b3064f1e0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "420391a8605212d4a0926e5e158547ae6aa2a2367b8dfd2a669ea07073fc9a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8c54804ee4ff01c074f9531975a3b876cea888ace455300a08a2243bf59c1d"
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