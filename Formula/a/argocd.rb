class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.2",
      revision: "8d0dde1388a92ca4dc0daacec5707f4378b9d06a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a12da047bd0010b9433a09188bd9a83470d218e741831b480b035c65cadd32b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c532b6352a0b807b28fc303b885ba85a566b64212332d9b8448fe63d51748f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19231bbb1e3544047a1393b8f1397e856b8e20da1cd3f9f8f2e0676bb5c9c147"
    sha256 cellar: :any_skip_relocation, sonoma:        "23cc37ddcd1e5a32f7e532c3045b2e38d3d18f379941de31a78a1ffcbebb85b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef2c75c9bc19fbc929a3022ca97b04ed848c6e55589b69c5f5abb059bfb3e0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb2670f4f9c2c5a3e7d74db4a07e5343be624d7479b161f07bd43533b913641"
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