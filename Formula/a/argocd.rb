class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.4",
      revision: "e1284e19e03c9abab2ea55314b14b1e0381c4045"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e1030a26fd24d248176d2ae5c753987d8877e3d80a7dbac77f6a3d3122449d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "876572e5cac30d726cb71ff55003b76689437843a2f2cd7146dfb2946ea56f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a2cfe9b451e56cc605a42decb459b4a3813c3f522d586c055f4d991e3fed096"
    sha256 cellar: :any_skip_relocation, sonoma:         "273ccf1c1c803828d6cf54f27d14167d6ebe32274ec86a9119e582800a7348a9"
    sha256 cellar: :any_skip_relocation, ventura:        "a91c3bbf507d5d5594dd6065d7372142f1a159f894204f662c3fcb20dec072a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d03d595370ed869abb7e34492a7725458fdc81e6a59a453009663538ee702498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f51ef5ec72be0685cc68fa6e6cf04d757d251012f9b4cbf45ccaf87b559eeb8"
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