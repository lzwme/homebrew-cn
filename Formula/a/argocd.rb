class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v3.0.1",
      revision: "2bcef4877285db808e47b862567b278c3793d056"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ae7912d85c319c7527bcb0656776ba920673b0b97f07338403f3451fec2ff43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c40b390482c38621fe1ccf00f59958fc5130b5dc42cd8d8c337cabce4171b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31d5978a7a74d9f41c28df8f9935fbaee44e71dcce95f29a92069b0e5750b24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8866aeb60be6ee0a02d6c140f47a62bb189c99856b17188c54d86c46d5e633d9"
    sha256 cellar: :any_skip_relocation, ventura:       "7472ed08c49c647bf8357d38d0515445a0135a0e35ec50768dca17d38ab7d261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4405d472692d404ff08d064d962f32b55396a97e27ddcc5e32703f13cfcc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9b66620c7be3a2d460ce2bf21c88b9cd5d7dea6f10d5fcdb6197f6c3c945f92"
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