class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.9.0",
      revision: "9cf0c69bbe70393db40e5755e34715f30179ee09"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "398d7f9655edb2b226226dcb3f73a8ad7a6d77ee64d11bb3cfd9169927d4d239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce1f7bba2e99689c7aa075e1c3ef61a26e355d8bf84d5cc290546e112349878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd298ec4ef28671e6be47e29b92fe7e7a984fe188b26c4b310f77c49f35dcc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "38e7a5a47eef2c743f160a571cd727b2cf9bb2a49d8fcf4681a7eb29c36af8eb"
    sha256 cellar: :any_skip_relocation, ventura:        "75cc2ad5a850d25cce1b18a1191f5c7c9653c921283d5ee81f8569b012df5945"
    sha256 cellar: :any_skip_relocation, monterey:       "fa26de098854121f16305f0a0d031ca895743b4769865a587c8aa64cb98fc2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be87fa6511507df7312384971922a18ed9089a782487164fdb3bb804258b6f9a"
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