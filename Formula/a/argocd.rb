class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.9.3",
      revision: "6eba5be864b7e031871ed7698f5233336dfe75c7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15cd029d16f0093abf2d00fb26ae2c2f986c63aa2e688615ebaed2c0c465ecf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37e2aa40862e05f9019cf92fe546b3b97a4b4ad4f293dac144be6b4fd89edc22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "142f2f67296d4f1390a191f3d392bd17a0e81daa490fa50cd15d4d5250efd900"
    sha256 cellar: :any_skip_relocation, sonoma:         "d08d5ff942d9f11d2619c8902c2138d2f2c5152a07d6d47958ec1f67e8d24265"
    sha256 cellar: :any_skip_relocation, ventura:        "9c1a730a6770a5f169e85271cf05a80fe40eef41349f4463303ebefb0c313b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "2248b19643f262f17dcfb12752219ad67334c8e56cefc519910ccae54e443cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43080c4409a54f52c1d2b810e693aa671611add835af5647e7b5cede3991a3d1"
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