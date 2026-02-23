class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.3.2",
      revision: "8a3940d8db27928931f0a85ba7c636e54786bddc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea38b9df4989a4b980b6adebb1c93b44e8df07d47699fea51b0ede0ca44a825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0e048a10b746b485ccc69a6b683793a81fd5967c0a2fc88b430d4fb0494cfc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e0d679d03103bac706f0a1495b7de128aa2bdec79c461437ce772879754a59"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d07b7a70b529bba1f82b6c25d66522a175b04a31a78e44e0824337b16a9f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd2eee8a42f7fdf53e5d2dcc04b434a5ee4d2a6291feb6813f72cd381d956b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c644a47d27477181a7aff230e4bf80a61b81064e5190c409b7f1334983599c91"
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
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
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