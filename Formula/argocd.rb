class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.1",
      revision: "5e543518dbdb5384fa61c938ce3e045b4c5be325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a01c7228183a1dc99c031b8a7d59a0fa2d2684812e03b66ae6e3afcc0aae9d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9545166410ffc07b9d46d9c270fa53364693f02e97cde91cb71ccdf620e70926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3576e60cde74dc3de2aeae8e854fcc52bef15f96429b305574ef3721906aaba"
    sha256 cellar: :any_skip_relocation, ventura:        "96e1978fb26901fa440fd35c5b2f6b9c8572eeea0be4c5653388148597dffcfd"
    sha256 cellar: :any_skip_relocation, monterey:       "f56173baed1dcdc7291ea0c4a4522c9751440acda10f823ed4dd1d6363ff0bfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "df2c94dde19f8a3cd29cf77f97d17c7400316321e84a9451b9b8e56ea76bb22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5595f181b56795ce9a165a34e0ce2fd9bfdc3c81f57474e2f3230b7ca3fc88"
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