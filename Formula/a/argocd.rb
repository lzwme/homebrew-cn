class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https:argoproj.github.iocd"
  url "https:github.comargoprojargo-cd.git",
      tag:      "v2.14.8",
      revision: "a7178be1c1ebe08a61e326037173d2ef979cb3f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c398b8b7b8f2c895089ef8e55db05269295e1adcca5430fbd6e8fc54a5cc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec849b5cc7527d280e182b90bcbb75a16f1eda17d8d5371ef032615e58d1d22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af22d0bd402ff358ad915445eb9568770bc4428d8620afc219f1d9ac721fc2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "29fd4a5ca24dcda7c56a7114b4647326dfd668081a6de0cf8c28fc808451f7ac"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d3498f9e6315e3ba50396260c8ece9d094a354389cc94a206e504c592c0ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cef0272d748f366fd8d4453e72db32deb42cacf32e7f0de8b4e721dfa99c1b8"
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