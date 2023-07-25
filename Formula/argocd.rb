class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.9",
      revision: "0ee33e52dd1f1bb944488584fc6f854b929f1180"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e13e494c6f5764ddb32705abba5c3cdf2dadd562b570509152961feeb208bbcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ebe5cb6b199a38a2154cbb811c13979477169bd5ba00ece9eade20e1dd5ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb43ee1d255d7f14f88e834056d097dad4ae669f32a1880205326a5df621231"
    sha256 cellar: :any_skip_relocation, ventura:        "6d37d3a78e7514d857ae74f61218aa3641df1c8943b82a15683b6744adf40276"
    sha256 cellar: :any_skip_relocation, monterey:       "8987941e1329196af473ca198f410ae72b2ff118b6c813797082cbdbad2370d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c5b0a37c8a2b038c07d69e8b534375cb725fb38dfd8736dd9fd52941d3b979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8ab2f67fb130c8f056e326d6ad06b9e1d1c615c94969247f81ac0c8e72127a"
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