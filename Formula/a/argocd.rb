class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.9.6",
      revision: "ba62a0a86d19f71a65ec2b510a39ea55497e1580"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f63457a401be68345b54ef646890de0de9ed48cc046e4ea9f9cb7264ae4bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b115d06fc66c2a35a7f409e3804f322e5e06c63d8c08807f82d1c80d1bb86129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "107550c5e749125b605d751402908e2b39ef40cffc80b8a0d7f6dafab5873715"
    sha256 cellar: :any_skip_relocation, sonoma:         "84d9051854617a8187a0d64da219081b022c0a65489da333f87214918a387d29"
    sha256 cellar: :any_skip_relocation, ventura:        "178c4ef070de679600896b09b75d33f0707716a5c8306e271785b019ba9cdd23"
    sha256 cellar: :any_skip_relocation, monterey:       "37025350bc3d2d0bf9305258b271a2348eef55da0ab80704685ed9f980dbf557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3473516339ef8f64b59863dda920a1938ff618ac0c52917258bbc3216aeff33"
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

    generate_completions_from_executable(bin"argocd", "completion", shells: [:bash, :zsh])
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