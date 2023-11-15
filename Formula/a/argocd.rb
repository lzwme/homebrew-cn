class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.9.1",
      revision: "58b04e5e11d007b0518853029ff7612c24a2eb35"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47402c1fcf9e9e4b8c596b37553b439fcf0537cb91ed3b3c11545c0021e3bd7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bb57661276e688b71df586b91fda8169ed06cd408f58457170d640006a40ebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64be1c0118e64de4e1fe20174f39b164492421288aae49e154ee3a582c21842"
    sha256 cellar: :any_skip_relocation, sonoma:         "acf129fbe503f2055adf44861f2691e52ce15be9799e70b819d3c711e0cc1c77"
    sha256 cellar: :any_skip_relocation, ventura:        "4a10905f836409a6fbb324cb1f5c92be3b7a3879a7082451482edefac77b6c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "a8601034a1c1fc2fdc78fa082b128c93ce5c383cd724d2e0e37e71d2ef8de8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1345505819bed8eb803531e6dd49b8fd188e92de8db84acb6372d90a84b9d87"
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