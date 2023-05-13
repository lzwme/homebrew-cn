class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.2",
      revision: "cbee7e6011407ed2d1066c482db74e97e0cc6bdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "999390219e84085428500a7b97d4559e6336c7e37d8fa991ba5b3305467e4042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2269d1fc76c30affa7b680e08f80317ed137df5bd54bb09c359dcce7df863671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6caf0d4b41f9e96db7916ef1c34b506addf1741e7eb4907e5db98e9313c6e418"
    sha256 cellar: :any_skip_relocation, ventura:        "4ded4d543f27548b425cf28d77fc373133627f3c09dcb486ebee8bf076401985"
    sha256 cellar: :any_skip_relocation, monterey:       "d896f7d377ef926ea8ffaef81921804dc52e2de15eee74b7a23b5baec1b0fe7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae14c615ed78177628ca24b34d23797bd98aa02ebc9ab2641c83a1f49f3486a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a329eec4eed6ae600527b0872c1046b47eca8b9dcf414ca6b15596c6a6e97ee5"
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