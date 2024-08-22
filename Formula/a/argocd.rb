class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.12.1",
      revision: "26b2039a55b9bdf807a70d344af8ade5171d3d39"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "393475b9b4bf9ca5858915d40f6bde5de7e2677df5de0137329fe9037ad3adba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5de3481c9d0f3d6322f9caf042ecc826bd03a972364b9d18a9662ae1d3b15deb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3590be47241ffc9cfa573954e41613760e278baef71eb6eab94a1fed23c8b487"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fe66c2ee9a81bbfe144674de5da16c61c01df47e900c93fb543b4fd4559cb48"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0f108e6197c40b00260a9f07a7df379e5753be82dfd0881b2259bf4cb39038"
    sha256 cellar: :any_skip_relocation, monterey:       "26998d1b0845981601f9d2cc73b195597215a43594f37cd543dbdce39a524591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ad5fe7f60fa993072e135351feb56798621e42d5a05ca32053e10362b9d723"
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