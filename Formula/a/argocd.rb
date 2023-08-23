class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.1",
      revision: "2bc94af7bd081bc4682c2c6dc005f6336c754c2b"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7da3ed68cf7237c12e0d8e95cf63aa65582d742b11f99e6d8af08491090eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d70c570a2e1d5bb14f58d2ce9d9f1379b0c8fcf56896ca79f36be1ff5cd42c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fda35283afb991d002cfb727b90411b32331b2ae757d98336587f6629235f6ac"
    sha256 cellar: :any_skip_relocation, ventura:        "43360e65bee5b955c8d929be8c15b8502f245bc338fbb8501c8cbbd170cd1691"
    sha256 cellar: :any_skip_relocation, monterey:       "3176d30abda329e34e1b8e8bb71fd8bcba84689e5eee542e11c4d2963562812b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6391c45b3eb4ac77718f5b2a230d43ffa97920486472624eda08bab955b75a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e6edbdb27e8ee19c40c2ca4b51806ab70111982cad0bee816aeee48002adb2"
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
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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