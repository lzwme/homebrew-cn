class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.12.2",
      revision: "560953c37b343c956f3a18f3db7d006e694c0dc4"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple majorminor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed6a3b379cf68b8195acfbbc915345c086bb8b00b0a1361177b76e2a2b993f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05ca2ac874f374969045e6ec278927a28dc67703f3d3129c261a464117e1c306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb5da3b5e1f8ddfd5fc50a933aed8ef97ff700a2051f895d234cb5936730368"
    sha256 cellar: :any_skip_relocation, sonoma:         "364ca45f0c087f1ed0368635e86e73165625ed0a52d630ca5d1d7acb47abf2d7"
    sha256 cellar: :any_skip_relocation, ventura:        "97dcec6f06c54512f2bbed487bea98f0d8da9db4f9f59c6715d4f283499e9d82"
    sha256 cellar: :any_skip_relocation, monterey:       "0d463da9216bf5e90d843c087e469b36554192f06c606a0a8aead3e756e56254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a10abc3cd64ea8a352f5376a04b92f1b9dba79bb6b0f431fbd867e5a1a12c5"
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
    bin.install "distargocd"

    generate_completions_from_executable(bin"argocd", "completion")
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath"argocd-config"
    (testpath"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}argocd context --config .argocd-config")
  end
end