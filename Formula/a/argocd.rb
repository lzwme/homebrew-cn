class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.8.5",
      revision: "b3ba6e1844548be490de550eb56fd3b4e2ea93a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6993d806199a1f7d9ea1bef170d3acc50a396f5b8b85a69615c1c59972cefe44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2eee15bfd5f53911b5877f98260c3cec8528a6c6b940a68e2bf06ed00d74be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8256c0ffaa782867d624990ed7594851f09c0c25e7d10174f82df37ffc1e30b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0068c05ea64c38e4799bae3a518fea2e262713f53b4bef0b2edd8f6b765b5688"
    sha256 cellar: :any_skip_relocation, ventura:        "0ab16a58ebc89f77fa999ea8ee5bebe63d9405a9bbf9bdebfb81d2acf50c3ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c7f00284efe63899a7ef4c744de16128c4065184a120423c03f7a340e089c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2cc5b0b4c5f28fc58886774331b6ba059348ff10ff5cfe1e08be158bf6dd9cd"
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