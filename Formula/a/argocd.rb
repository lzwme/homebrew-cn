class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v3.0.4",
      revision: "5328bd58e6255e31c858cc1b628552d32bd105e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06e854e2d34eaf8524873fb69bea4ac96b8a00db107d7c76b30465b380e3e22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "421945ff5b19959c295dc30cf9c2475f00e5a9fc39fa8eb625b9b12e5999669e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "867808239b555b703bfc722048d5fb15c31c92666f977f6f1d7df841184e1707"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa8239e049d18b150d971b0049117d020534355b593f59392639115569e8491d"
    sha256 cellar: :any_skip_relocation, ventura:       "7b033611e5e87b593133b5a652446b57b60af82b0818027a707b92cbd29fb1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b83692e9fb659f924d031c2f2b0647a244c45c4d2ab91e8330e31a410db12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43ebee0797c83d4616a8601833aaa1ef119a01edacc2522c929f358e619d86c"
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