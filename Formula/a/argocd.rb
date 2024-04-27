class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.10.8",
      revision: "37b1cf5306f9c245f188c4c0566c23a0f80cdc65"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e47e8997b8f31375df3366fbc3f729f1f5d025227a22dcd4726c48656c86970"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c94a26a81efd47afcb3dd7f8d11d4497fe7255e836995ab38dd1794b26506b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e18d3f29c4535095d4af8af3f200a1726c8d8311bc1571c2cedf3c0552b954"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c4ce1b378a4aff0498d9d25d5f0a796a6cb68cb22e725e41364f13391bd5a9"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4154cb508c0361bc52bf4519326e918e90c9db03345c153789d39141afbb35"
    sha256 cellar: :any_skip_relocation, monterey:       "e7be3e3046ce11d891da668b8fae12147c35f22ebc309430d777bdbf978b9cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025aeff821907771ff77e193648c7eb468549b42dfdd2cd9a9a07c24c84a01b0"
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

    generate_completions_from_executable(bin"argocd", "completion", shells: [:bash, :zsh])
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