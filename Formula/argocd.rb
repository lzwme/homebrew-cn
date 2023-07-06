class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.7.7",
      revision: "4650bb2817c3c81405f40cf77e93ef2b5fb275fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "229f62f981a4f145ffccc8c104174950434ad4c8c8a02350922af92ef2ed436d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eac1a39797d6a330fc777120fb0b9f286be8e666bb2427c99885859be4a7e6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305547f017f425386fa8303b5d38b09e1ced5bbe26df2c43428e2a85f3e7ed88"
    sha256 cellar: :any_skip_relocation, ventura:        "32db66374d40840592df7f0122407f70d36ea0733ed965465da707496fc0d6bd"
    sha256 cellar: :any_skip_relocation, monterey:       "367c32c62245cef107f8d2b1afa63518c5a9a2283acd9ef3e9a4805dde9d9e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed52e58e696a3cb97e2688e79a4c0d2c462cd3e7d12b68e2b1e3482e99a836b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6a6ba5a5561a78f5a8cdaf1ac6a98751669569a44e7db079abcefe879ecabb"
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