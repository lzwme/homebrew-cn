class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "118767ba5b0a506fcb1636f8aa33e122df738f65aaef6b50cfbeb594d22d9620"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3968f29aebfee511a368149ac7eccaabef9390fb68a6882b27989249d9c75030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "788233e41f0942e3e05f21cbcdca94f5a06f0cf8269517f63102dcbd4b467654"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cf55727d530e5d4c09e39a16eda30ec64df76880f9ef8c6d49a71d406fee862"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0f889b00eb5f0996aad68406c08e60545fdfec8dda6e3edf5016ee8b05ecd4"
    sha256 cellar: :any_skip_relocation, monterey:       "6120ad171fcb706d141adba7c41831a869c607673e618125159f665450cfe943"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad236b12819e3bd5bc10e2489edaba993c72bb6716b00d23e73dd38b8188c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3149880af54a6291b03aa5156b01408b1db15ac0ddafab68ecdddef947f76866"
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