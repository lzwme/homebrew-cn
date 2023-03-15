class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.5",
      revision: "60104aca6faec73d10d57cb38245d47f4fb3146b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0613023ce27ba5074e3eae04135176d500dd31da5697d7fddcca3ab849c6a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b601bd17e1405700cb5518960b201fde0bc1d3812c73c761360ac0f92004b48f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2957dec3e33684e07f57e60786df6ef9f49eeb8c7ec9057a40875efbc23548"
    sha256 cellar: :any_skip_relocation, ventura:        "7b5ceb8977b186b17f45c70ed22f5fa6f13ed9ddd8299906b61addda614d52b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f61d14a43b3c9876e4811ac59bc98be78b958dcc1947fe36e6065b41a037afe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7a719b245585f755c170428753de2edaa804ba4c559d3967158df8db93955ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5040a46aa456f8a3fb357be6c4ea3bdc7aff1f10650eca0e36c503bd3ad892e9"
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