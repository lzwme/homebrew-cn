class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.3",
      revision: "c1467b81bc2f7c4b8c3c39c3157c7fa06bc1b34d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76e8de56ca36dce147d7530516d966540049afe4b4c7f04637f85256ef87ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1923c37f1e9230b25cc32cd4c6ab94592b2e6c10c4d11c08643e8a3a06df924b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecea01d7ef2480e914bcb7a0c00334e0de674f2d9890b400c11c592be4698065"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfa76514e7ed6e375c32bc9590f2f616b06645d69d217a27525dc8334bacf029"
    sha256 cellar: :any_skip_relocation, ventura:       "1cd0205105689f40349df954b1be74af4e30443a30885afd362406075c2b7d1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e46e4599c3d684225901caa48d4a0df5bc80ad5247f6566955230856efc5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa46db99364e2a59395a443c0f52e5b58e0f52a656189e67443cace9be32537"
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