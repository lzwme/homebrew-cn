class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.5",
      revision: "a5038b0e2bbac1715754380ae0084df8e3d5b48c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13256f768d8e22001e710a7a5d9d486bae06c3d31a36418161b56dc07b413f0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ccd4889eee8e1f0364ccf03a977682cead28b9f656abb47fa67b40c1b8203baa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42f9bdd62ddf0d31bbf0d81537498a0069bf380f9d395a079b1f31af1b6adb75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b5957dd7c28a45beb015e3cb57eec565f9c895c3c6f7a1bd1ed4382d59238c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b998e63c67f2b781c294cf94c632ac094ab0557b95aaa1fc05175e09f33b7d1b"
  end

  depends_on "corepack" => :build # requires newer `yarn`
  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "go", "mod", "download"
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile"
    end
  end

  def install
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      cd "ui" do
        system "pnpm", "run", "build"
      end
    end
    system "make", "cli-local", "GIT_TAG=v#{version}"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls an Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end