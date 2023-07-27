class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "a028affb092d22db8bd2fb60120526d309af016260b16f0af99eb8f28dcb716c"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abefc87df47b9f3597da9a9e57884a6f9a27155e6fdab1ec9a39879f2c180538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb2766c3b47d2f97a2074311a1ae92ce995f6c61b88a20bf2c6c14dcc02be9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "735050603d566296470ac059abf5180a454dd36d413b92463964558a458fd3ec"
    sha256 cellar: :any_skip_relocation, ventura:        "43bcc118ecd8379b688594ab24dce3fec3305383333a61c5ce6fbfd285f51f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "dbc343a1fe37c7c6db4940c2fd4dbe59cdeeec24dc1bc9b60071184c5efec18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5832803371b9eced6b10c2fa831c774b5c8db5309cbaa9fa4c61725e82e82666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd07a845e2aa840e7b9b85f7c00933aa9a1a0e2002673c04af19ecf78a0b0ad"
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