class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.4",
      revision: "d6d5b248ce00e1a2c512068002a93d3319767087"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1577f2ed4a7d02d9c33c9323620f8a4d5627844a9b58eeb651da2f510fa80d0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29dd3491f23773e6e00965f99b4efdd7a5d432c1f20be2385a4415c71edd53d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "440ae4ed0d1b0f0427267a08062f944043b8961df8f748b014733f3c400716ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "abdcd7e2c86493f56d1128e472abef24a9e5c7bd0eb984cc72cad4c3eb87c664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "734c13f043b9765b433d2be9ad0b76aaa4bc2f3eab13703a82d04cf93a13db2f"
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