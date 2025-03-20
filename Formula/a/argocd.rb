class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.7",
      revision: "d107d4e41a9b8fa792ed6955beca43d2642bad26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dac83f45ba333cdd265eea36b63f116daaf9e255a3c61695fc656ca22f30e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0f2a6cd04ace9e993f0f8e9fbeea168e10b6ed8607262e41edaf5a19294d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50cafdf6c89d76adb8fd7225fc2b56317bac5bf9b70c220e9c78b35bd60a86f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "39fb3af0ce9d81e07345c2bb62d0291669bb76b69ac69c493bf1586b5cdc135b"
    sha256 cellar: :any_skip_relocation, ventura:       "72506b83e37b2108cd28548f6d3f490b457e3008b7d8b0fd70b4c8d8cd48421a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76a6e837d246404c17e099ba5d885b5153b6cfa7b2fecd0822024ae5d6e7f92"
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