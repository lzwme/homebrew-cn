class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v3.0.3",
      revision: "a14b0125fe02ff953caffc59e55016e5872d45bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3472d6c9049fd6c1b8cf04528185052dd7d958fbd9938392e2f6da88242adfc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b29abf27fbb29ae6bbe749e1d5bb5a824df6bdcaf0cdb25076969cca7d1c3ee2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac3418cef819656440b0c8e9a2b6aa621a7fdc27dcb54595312f27e84e4d69d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "11667e532dd5fcb0282fb26ea6036035bda5847bff18f86cd19a8f881246884b"
    sha256 cellar: :any_skip_relocation, ventura:       "89bbec6808ee2a27daebc4cdf1980c02c0eb05b70f92fc1b32c1ee40811e8def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d12fd476a44b1e36c02bb902275f91c633bdd604e1585cd3052f161d307d927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "287e957e4addebf5394aa54d4c3a38828e77a03478b75a3107a56649bfb337d3"
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