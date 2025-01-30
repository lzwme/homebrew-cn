class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.13.4",
      revision: "102853d31a22e2031ad76bdc0b673d61c7c2cd89"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e85b830f9bfcd03a6da341c564ebc2f83557f4ec5fa48a8c83b7f9fd371ec437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e6bdc20b3f1c8d4754035fc03544c96b41657d260464ae7dab292ff560159c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1bba705e6621833aa928f65513a177e65da35cf1779890926686eb0bbc277dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea3a9abb4eaff6d6c0570eac8edf14c52f1f543bddbfeab3e0b85c98c8da7da"
    sha256 cellar: :any_skip_relocation, ventura:       "2800c6568aac5123b36929ef8f73be4f94b41f91dd6090358e81ca919ffd4748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8042965a6f3fc1580924d3ca4813efbaa1d42a2515737a5ea0872b3de807a6"
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