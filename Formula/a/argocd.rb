class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.5.0",
      revision: "e95e1be88a2da6c06bff5c2fe1791e4d233ed810"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc7dd8768b45fa49f32c94f7902a9d7ea8f7d8c759331a07d6146094c6c15bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf67e7c5c35105e4b6713b63d42f386241445cd456016e5a3001d38a0c1361e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c517b8e69233b55eeb6a45ffa902e02ff774f97ff92f97b4ffe0f43d41abfc34"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da01b36b22bd7da053660222e9270d43ec6eb45c7acf88fd6731126f6c69d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c32decde534f5ae9ba58d6502d5fd8e5a702d33f3f692faa0b19d64b540df99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d31dbc8adff102e517e5a24187fcc9be6613c924b54403baeeffd62372fe8a"
  end

  depends_on "corepack" => :build # requires newer `yarn`
  depends_on "go" => :build
  depends_on "node" => :build

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
    assert_match "argocd controls an Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end