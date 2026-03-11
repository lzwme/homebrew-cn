class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.3",
      revision: "ff239dcd20c578ecbf5265914cdc5c2f98d85535"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5fd2101b02be3021ec24204d9603955f66dbc6715c0ebed5ff356943dd3a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6385dc751fc272574cfa6a035b35a2b4bb5bd719a5adcda279355cedcc454094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb30cae42f277550a469021e6fb5b50e02632578067669b9010d40cf91c1c1d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "db468bf3724a1f3a86a19baf49d4ebbb9eb3858adbd09de38eb20e6682af5e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070344a2c1064d535df3d204ebcd8a015751a0e51b4e64f49eb6d9bd217d2b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57cb277a7ac92b1c5c79f2e03b7163fe8464e1c1777837e955991d556fb1ef9c"
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