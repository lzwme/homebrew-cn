class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.9.5",
      revision: "f9436641a616d277ab1f98694e5ce4c986d4ea05"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f39e4c6293c0d825fd6703ce0b3d479662165576625b42906728e0656f2f5572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8765fa53d4e0f94a1af48e810cb169ebf9c565171529536c2840e39373ffe07a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb5634579b29fcde248c910dbfb6a26a3043544d5d62eb3a7706fb46c6b9779"
    sha256 cellar: :any_skip_relocation, sonoma:         "c49ad835b5a1faa9a5517c07b6d93de24a205e1199f72488266d3e7a8e67d29a"
    sha256 cellar: :any_skip_relocation, ventura:        "9c004b4d084133ccd3901b793e9545d9b6070aa0021123e44415056323298cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a726b36156af687ecd51f5791a7c191394d556642d5edb38517c3a123ec0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7d3227adb5612699345ba42112dcb62841adf9605090e0997e4105a734cf7e"
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