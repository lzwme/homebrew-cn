class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.6",
      revision: "fe2a6e91b61299a476cc25948cbb53eb1ca1cc14"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231263a3f04e771f4480e73e9391d1c1cd525b87d1cf5bc1e87dc92b54a1dd18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb64ddaa942975e21f840a9e06d3a1003e3a51fd28beb121e959ab8e6a717fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a63865b9eb8b3da762b430806d8d4d725c5dfdc10b7bd59245f53869e4d5758"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5e4dee9e18d1a5a0d55303fc4ebbb821492f83de8ec9579242b786f61af7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "fa69cd2082093a346ccc3e676e186fb0bfff10a50148cfdbcf462a6ad0b94063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbf387a358becd6e9ca380ceb48f0f711e154b5a34abe611334e989c83b9624"
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