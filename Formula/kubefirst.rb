class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "86b58c0e5b53db7ba5d1b5ea38b9948fe6721e660ee8c1852886b7783e12f002"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274a6896e17738155107c49395e6a2235a90470d51a489b6ed26aa6380271e83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c7b5cad687e2096f9ff1c3ad6102d9081bd1836953ec48be99604ee9d038c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ead25df74e58f4bf4faa8cb8ffc5fc195182fbf9d6f008428305d24c7c29b8"
    sha256 cellar: :any_skip_relocation, ventura:        "7674c182354a53edbbc90cc9f80d497dab260fd191c04911f37a9ab0a932e841"
    sha256 cellar: :any_skip_relocation, monterey:       "c7929a0be55e1b026b991bb4932e000ca14e08b5000b4b83a1691c10122a4794"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0cba27e16a635375dc7cdc21a6ba87e9702fa7abde4903ff9495324e391d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d477ede29196568f2929f4d321e2159b26966f13b1f990f5886f6240ed66942c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end