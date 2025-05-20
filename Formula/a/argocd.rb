class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v3.0.2",
      revision: "8a7c0f0c86b4a189669041fd4df671316fd4c977"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "458fec338a0f394aeaadceee9970c541ac9f03a2079ac34a921a7329111dad92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199bbdd754ea416930f115e8f33ed056939ecc06c6cd511ccab8a5b3147de82f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae78b0a7ab1fa1a455efe36412189b5cecaecd7813244e2e529625aa3ff538d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2125de3055d1135f0b2faa85652c4596c882964b31402c225078a593f6d4613"
    sha256 cellar: :any_skip_relocation, ventura:       "af5305331775d4fa5ccbcd5333841de069d197dbe275cb0ad525391d32adfae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e250beb2234f92e9ff1c86c76f6133ae81b3beeced61a9bc2d73529196f4e9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06578bcbd22d9452867503a3a7ae9747cb7dd1da2528ce5eea74ac9a54318127"
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