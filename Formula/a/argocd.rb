class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.2.4",
      revision: "030b4f982b2a0f6a97cb3d3f3616c14df0f58c48"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eadf482e0e42e75efd390668c35ea76fd47c2c1538ae96c69170b0202156994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e176edae4ccdd41801b8f09e772eb6c5b818e50b57367337e98763812210cdd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5803f16654cc002812373be600ca734889051bff3486908d2c1409251dac8eeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d5ecebe63b3f93309edade28c2c97c56090f65f31c8941becd80c0d7ab4f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe109f5c4ec8d3d0387674ea81d6d9bc6b2163488effd58e802575dcd3f5c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9678c8e41d392cdb78d51795d19aace15d4fc7ba847944b0ede0194e4d5926"
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