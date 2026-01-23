class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.6",
      revision: "65b029342d656c03c57f0d0e14433438750c8f5d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f37f6f2bfaf186a83252314ee34ec0072750ae2b4dada28d4b5b45a0a2e12b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198247b1697f57aab0fd52489da1a8ca61e24f7dae97167846328c269fd6abaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0efe91eb9b42aadcd665c120ef368e402f87dcbadb14016d4ae73409d8b8261a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfc391a377fa00f7572307003c71ead7febb211f8728611b1df623a01b3dfa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efc0cd212d4f7d4b92f900c8cc9487178e164086d49660a51abf53fa41a65d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1d557a8ee41b145bafbfe61374ed2963e6be1b71efeff600f9499c97101f54"
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