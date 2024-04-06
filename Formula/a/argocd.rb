class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.10.6",
      revision: "d504d2b1d92f0cf831a124a5fd1a96ee29fa7679"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb8d57b1937f081406f2dee0e813c6c30a568194e509d0de13cab9ff9b3e36dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4370ac8f9f5983a15e6980024a5cf5f4409485b7e5cb79801eb5cb9500a62920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ecf3152c9b3463789e15721920b31e8314ec3c2f5c2702bf0cb3f93d9b4fe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6dab56fe4a42b3127415dfe7e1a15741a4d3706c60702e0932e73608f320bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "5992447e29db9177fdf758a81633ceb432e8e116ef76b63e9df09abaa7a15cce"
    sha256 cellar: :any_skip_relocation, monterey:       "574f01dae160499e519c2563cae60120d564e893b228adb94dfeb591a347eb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b286b6c024b6a9faa5d0d88bc9ea6b4a38046b6cf6e9e1f44aed701a6ec16d"
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