class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.7",
      revision: "035e8556c451196e203078160a5c01f43afdb92f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9d6645a40e59e19f58d052284a997af474cdc8158bd70b041a06e6e78baa1a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f8a7f78f78f169b371552982d2c3e08070a9ff6c3829074c664231a46aa935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046091e11a105ae4e4aae2487ce1796e3658c6261017e2be0fd3ec4a7f652f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cfd7abc304bc4e2118d67d62b20034d2bddf713f86571dd771fcb29cb5268ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7672b88aecf278e2f0a54a5d71fb2a02ad5980eefd37827b709b7f9654cdb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d6a7ba397973cabbf30ee6fdbec2b9f5cf9ebe88abd33aadf428b65f3b68c2"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
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