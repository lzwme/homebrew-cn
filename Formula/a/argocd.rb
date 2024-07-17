class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.11.5",
      revision: "c4b283ce0c092aeda00c78ae7b3b2d3b28e7feec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9929f71d4f6123a59ca920396573c0db55b94a48c5f0065cdce030ac5fd43a6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a050c1c8f13277312ecceeb317a7c5aef46241a18dc68bdecdebffe3041fc3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e896bf2751b74ad81648ff5b9ae3c3a763acbed1b57af7fee808278b013dc56"
    sha256 cellar: :any_skip_relocation, sonoma:         "a73f564ea8cd7f99cabc526930a0dd883ddb59ab6a2487989126309938ee63f8"
    sha256 cellar: :any_skip_relocation, ventura:        "10b17b451b20854398fd8afc47aba2e1bc3a55d5c8c9ebe2dcae657c54cf90cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c1ef2ded6918dc8964a97e584affd5653741e24d1fde3a5bf3623b764e600000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7131ce0b766ecdeefe789359abca6babd520670cffcaba7a5bc262868412852"
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